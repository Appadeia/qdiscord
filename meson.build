project('Desucordo', 'cpp')

qt5 = import('qt5')
qt5_dep = dependency('qt5', modules: ['Core', 'Widgets', 'Quick'])

processed_files = qt5.preprocess(qresources: 'qml.qrc', dependencies: qt5_dep)

executable('desucordo', 'main.cpp', processed_files, dependencies : qt5_dep, install: true)
