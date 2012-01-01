/* 
    This file is part of Trites.
	Copyright (C) 2011 odamite <odamite@gmail.com>

    Trites is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Trites is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Trites.  If not, see <http://www.gnu.org/licenses/>.
*/

/* Data about the game area */
var blockSize = 18;
var boardWidth = 10;
var boardHeight = 20;
var maxIndex = boardWidth * boardHeight;
var board = new Array(maxIndex);

/* "Bag" for random generator. Read: http://tetris.wikia.com/wiki/Random_Generator */
var bagIndex = 0;
var pieceBag = [ "PieceL.qml", "PieceT.qml", "PieceO.qml", "PieceJ.qml",
                 "PieceZ.qml", "PieceS.qml", "PieceI.qml" ];

var componentBlock = Qt.createComponent("Block.qml");
var currentPiece;
var nextPiece;

var level = 1;
var score = 0;
var goal = 10;

var seconds = 0;
var minutes = 0;
/* TODO? Hours, days, weeks? */

/* Define different types of collisions */
var Collision = {
    None: 0,
    Side: 1,
    Block: 2
}

/* Game board data is stored to 1D array. This function helps to
   convert 2D position to correct place on that array. */
function index(x, y) {
    return x + (y * boardWidth);
}
/* Create new random piece and add it to the game */
function newPiece() {
    bagIndex++;

    var randomFile = pieceBag[bagIndex];
    var component = Qt.createComponent(randomFile);

    if (component.status == Component.Ready) {
        currentPiece = component.createObject(gameArea);
        currentPiece.blockSize = blockSize;
        currentPiece.pX = currentPiece.startX;
        currentPiece.pY = currentPiece.startY;
        currentPiece.spawned = true;
        currentPiece.animLength = gameTimer.interval * 0.75;

        var col = checkCollision(currentPiece.pX, currentPiece.pY, currentPiece.pRot);
        if (col == Collision.Block) {
            root.state = "hiscoresEnd";
            textFinalScore.text = score;
            rectangle2.x = 0;
            nameField.focus = true;
        }
    }

    if (nextPiece) {
        nextPiece.destroy();
    }

    if (bagIndex+1 > 6) {
        pieceBag.sort(function() { return Math.random() - 0.5; });
        console.log("New bag:", pieceBag);
        bagIndex = 0;
    }

    randomFile = pieceBag[bagIndex+1];
    component = Qt.createComponent(randomFile);

    if (component.status == Component.Ready) {
        nextPiece = component.createObject(nextPiecePlaceholder);
        nextPiece.blockSize = 24;
        if (nextPiece.startY == 0) {
            nextPiece.pY = 1;
        }
        nextPiece.anchors.right = nextPiecePlaceholder.right;
    }
}

function startGame() {
    blockSize = gameArea.height / boardHeight;
    console.log("block:", blockSize);

    score = 0;
    level = 1;
    goal = 10;
    gameTimer.interval = 400;

    scoreText.text = "Score:\n" + score;
    levelText.text = "Level:\n" + level;

    /* Destroy old content of the game board */
    for (var i = 0; i < maxIndex; i++) {
        if (board[i] != null)
            board[i].destroy();
    }

    /* Initialize game board */
    board = new Array(maxIndex);
    for (var x = 0; x < boardWidth; x++) {
        for (var y = 0; y < boardHeight; y++) {
            board[index(x, y)] = null;
        }
    }

    if (nextPiece) {
        nextPiece.destroy();
    }
    if (currentPiece) {
        currentPiece.destroy();
    }

    /* First pieces pieces must be random also */
    pieceBag.sort(function() { return Math.random() - 0.5; });

    /* Finally create first piece to begin the Game */
    newPiece();

    /* Start game! */
    gameTimer.running = true;
}

/* Check is current piece in defined position and rotation */
function checkCollision(newX, newY, newRot) {
    for (var y = 0; y < currentPiece.pSize; y++) {
        for (var x = 0; x < currentPiece.pSize; x++) {
            if (currentPiece.collision[newRot].charAt(x + y * currentPiece.pSize) == "1") {
                if (newX + x < 0) {
                    return Collision.Side;
                }
                else if (newX + x >= boardWidth) {
                    return Collision.Side;
                }
                else if (newY + y >= boardHeight) {
                    return Collision.Block;
                }
                else if (board[index(newX + x, newY + y)] != null) {
                    return Collision.Block;
                }
            }
        }
    }

    /* No collision BAD, block collision GOOD! */
    return Collision.None;
}

/* Update the game */
function updateGame() {
    /* Check is there collision on next position of the piece (one down) */
    var col = checkCollision(currentPiece.pX, currentPiece.pY+1, currentPiece.pRot);

    /* If piece collides bottom or another block:
       Save the piece to array, create a new piece and
       check have the player filled some row(s). */
    if (col == Collision.Block) {
        savePiece();
        currentPiece.destroy();
        newPiece();
        checkFullRows();
    }
    else if (col == Collision.None) /* If now just move piece down */
        currentPiece.pY++;

    /* Checking side collisions here isn't necessary because it's just
       needed when block is moved side ways (it's done in function movePiece)  */
}

/* Rotate current piece */
function rotatePiece() {
    var tmpRot = currentPiece.pRot;

    /* Pieces like Z, S and I have only 2 rotation states instead of 4 */
    var maxValue = 3;
    if (currentPiece.twoRotation)
        maxValue = 1;

    /* Keep the value inside array because it isn't
       smart to try to get value outside of a array */
    if (tmpRot > 0)
        tmpRot -= 1;
    else
        tmpRot = maxValue;

    /* Do rotation if nothing is blocking it */
    if (checkCollision(currentPiece.pX, currentPiece.pY, tmpRot) == Collision.None) {
        currentPiece.pRot = tmpRot;

        /* Do 360 rotation for normal pieces */
        if (!currentPiece.twoRotation)
            currentPiece.pRotReal--;
        else /* Rotate back and forward pieces with 2 rotation states */
            if (tmpRot == 0)
                currentPiece.pRotReal++;
            else
                currentPiece.pRotReal--;
    }
}

/* Move piece left or right if walls aren't blocking */
function movePiece(dir) {
    if (checkCollision(currentPiece.pX + dir, currentPiece.pY, currentPiece.pRot) == Collision.None)
        currentPiece.pX += dir;
}

/* This function saves form of current piece to game board array */
function savePiece() {
    for (var y = 0; y < currentPiece.pSize; y++) {
        for (var x = 0; x < currentPiece.pSize; x++) {
            if (currentPiece.collision[currentPiece.pRot].charAt(x + y * currentPiece.pSize) == "1") {
                var b = componentBlock.createObject(gameArea);
                b.blockSize = blockSize;
                b.x = (currentPiece.pX + x) * blockSize;
                b.y = (currentPiece.pY + y) * blockSize;
                //b.rotation = currentPiece.pRotReal * -90;
                b.bColor = currentPiece.pColor;
                b.spawned = true;
                board[index(currentPiece.pX + x, currentPiece.pY + y)] = b;
            }
        }
    }
}

/* This function removes one line from game board */
function removeRow(row) {
    /* Remove given row */
    for (var c = 0; c < boardWidth; c++) {
        board[index(c, row)].destroy();
        board[index(c, row)] = null;
    }

    /* Increase moveDown value of blocks over the removed row.
       It's not posible to modify block's y directly because then
       nice falling animation (implemented with Behavior) doesn't
       work properly when removing multiple rows. */
    for (var y = row; y > 0; y--) {
        for (var x = 0; x < boardWidth; x++) {
            board[index(x, y)] = board[index(x, y - 1)];
            if (board[index(x, y)]) {
                board[index(x, y)].moveDown += 1;
            }
        }
    }
}

/* Check is there full rows and delete them
   TODO: Make faster by search full rows just from 4 rows? */
function checkFullRows() {
    var removeRows = new Array();

    /* Go thought the game board row by row and search for full rows */
    for (var row = 0; row < boardHeight; row++) {
        for (var column = 0; column < boardWidth; column++) {
            /* Row can't be full if there are one empty column on row.
               If one is found skip to next row. */
            if (board[index(column, row)] == null)
                break;
        }
        /* Row is full if all it's columns are blocks.
           When this happens add the row array of "rows to be removed" */
        if (column >= boardWidth)
            removeRows.push(row);
    }

    /* Go thought the array of "rows to be removed" and delete them */
    for (var i = 0; i < removeRows.length; i++) {
        console.log("Remove row", removeRows[i]);
        removeRow(removeRows[i]);
    }

    /* Go thought the board again and move correct blocks down.
       Read comment from function deleteRow */
    for (var x = 0; x < boardWidth; x++) {
        for (var y = 0; y < boardHeight; y++) {
            if (board[index(x, y)]) {
                board[index(x, y)].y += board[index(x, y)].moveDown * blockSize;
                board[index(x, y)].moveDown = 0;
            }
        }
    }

    /* Use "standard" scoring: http://tetris.wikia.com/wiki/Scoring
       Some scoring ways aren't implemented (e.g. T-Spin). I don't know will they never be implemented :( */
    if (removeRows.length == 1)
        score += 100 * level
    else if (removeRows.length == 2)
        score += 300 * level
    else if (removeRows.length == 3)
        score += 500 * level
    else if (removeRows.length == 4)
        score += 800 * level

    scoreText.text = "Score:\n" + score;

    goal -= removeRows.length;
    if (goal <= 0) {
        goal = 10 - goal * -1;
        level++;
        gameTimer.interval *= 0.9;
    }

    levelText.text = "Level:\n" + level;
}

var isPanning = false;
var lastX = 0;
var lastY = 0;
var relX = 0;
var relY = 0;

function mousePressed(mouse) {
    isPanning = true;
    relX = 0;
    relY = 0;
    lastX = mouse.x;
    lastY = mouse.y;
}

function mouseReleased() {
    /* Screen is tapped when mouse pressed, not moved and then released */
    if (relX == 0 && relY == 0) {
        rotatePiece();
    }

    isPanning = false;
    relX = 0;
    relY = 0;
    lastX = 0;
    lastY = 0;
}

function mouseMoved(mouse) {
    if (isPanning) {
        relX += mouse.x - lastX;
        relY += mouse.y - lastY;

        if (relX > blockSize) {
            movePiece(1);
            relX = 0;
        }
        else if (relX < -blockSize) {
            movePiece(-1);
            relX = 0;
        }
        if (relY > blockSize) {
            relY = 0;
            updateGame();
        }

        lastX = mouse.x;
        lastY = mouse.y;
    }
}

function saveHighScore() {
    var db = openDatabaseSync("TritesHighScores", "1.0", "Trites High Scores", 100);
    var dataStr = "INSERT INTO Scores VALUES(?, ?)";
    var data = [nameField.text, score];

    db.transaction(
        function (tx) {
            tx.executeSql('CREATE TABLE IF NOT EXISTS Scores(name TEXT, score NUMBER)');
            tx.executeSql(dataStr, data);
        }
    );

    showHighScores();
}

function showHighScores() {
    highScoreModel.clear();
    var db = openDatabaseSync("TritesHighScores", "1.0", "Trites High Scores", 100);
    db.transaction(
        function (tx) {
                    try {
            var hst = tx.executeSql('SELECT * FROM Scores ORDER BY score desc LIMIT 10');
            var hstxt = "";
            for(var i = 0; i < hst.rows.length; i++) {
                highScoreModel.append({"index": i+1, "player": hst.rows.item(i).name, "score": hst.rows.item(i).score});
            }
                    }
                    catch (e) {
                       console.debug("SHIT HAPPENS: " + e);
                    }
        }
    );
}
