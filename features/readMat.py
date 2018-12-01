import scipy.io as scio

class readMat(object):
    def read(self):
        dataFile = './feature_test_gallery.mat'
        data = scio.loadmat(dataFile)
        print(len(data['features']))
        print("keys === ", data.keys())
        #__version__', 'features', '__header__', 'names', '__globals__'
        print(data['__version__'])
        print(data['__header__'])
        print(data['__globals__'])
        print('----features----')
        print(data['features'])
        print('----names-----')
        print(data['names'])
        print(type(data))
        print(type(data['features']))

        dataFile = './feature_test_query.mat'
        data = scio.loadmat(dataFile)
        print(len(data['features']))
        print("keys === ", data.keys())
        #__version__', 'features', '__header__', 'names', '__globals__'
        print(data['__version__'])
        print(data['__header__'])
        print(data['__globals__'])
        print('----features----')
        print(data['features'])
        print('----names-----')
        print(data['names'])
        print(type(data))
        print(type(data['features']))
readMat().read()

