project('Desucordo', 'cpp')

qt5 = import('qt5')
qt5_dep = dependency('qt5', modules: ['Core', 'Widgets', 'Quick', 'QuickControls2'])

incdir = include_directories('include')
processed_files = qt5.preprocess(qresources: 'qml.qrc', moc_headers: 'include/simplifier.h', include_directories: incdir, dependencies: qt5_dep)

executable('desucordo', 'src/main.cpp', 'src/simplifier.cpp', processed_files, include_directories : incdir, dependencies : qt5_dep, install: true)
