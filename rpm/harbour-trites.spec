Name:       harbour-trites
Summary:    Trites is remake of one of the best games ever made
Version:    1.0.0
Release:    1
License:    GPLv3+
BuildArch:  noarch
URL:        https://github.com/Tomin1/trites/
Source0:    %{name}-%{version}.tar.bz2
Requires:   sailfishsilica-qt5 >= 0.10.9
Requires:   libsailfishapp-launcher
BuildRequires:  pkgconfig(sailfishapp) >= 1.0.3
BuildRequires:  pkgconfig(Qt5Core)
BuildRequires:  pkgconfig(Qt5Qml)
BuildRequires:  pkgconfig(Qt5Quick)
BuildRequires:  desktop-file-utils
BuildRequires:  librsvg-tools
BuildRequires:  qt5-qttools-linguist

%define _binary_payload w6.xzdio

%description
%{summary}. The original concept was developed by Alexey Pajitnov and released
%under name Tetris.

%prep
%autosetup -n %{name}-%{version}

%build
%qmake5

%make_build

%install
%qmake5_install

desktop-file-install --delete-original --dir %{buildroot}%{_datadir}/applications \
                     %{buildroot}%{_datadir}/applications/%{name}.desktop

%files
%defattr(-,root,root,-)
%{_datadir}/%{name}
%{_datadir}/applications/%{name}.desktop
%{_datadir}/icons/hicolor/*/apps/%{name}.png
