import coremltools
import os

model_folder = '../20180913-112357-651b_epoch_4.0'
snapshot     = 'snapshot_iter_15000.caffemodel'
model_name   = 'MNIST'

snapshot = os.path.join(model_folder, snapshot)
deploy   = os.path.join(model_folder, 'deploy.prototxt')
labels   = os.path.join(model_folder, 'labels.txt')

coreml_model = coremltools.converters.caffe.convert((snapshot, deploy),
													  image_input_names = 'data',
                                                      class_labels=labels
                                                   )


coreml_model.author = "Nik Willwerth"
coreml_model.save(model_name + '.mlmodel')
