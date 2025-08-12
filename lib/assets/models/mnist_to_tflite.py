import tensorflow as tf
from tensorflow.keras.datasets import mnist
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense, Flatten
import os

# Charger les données MNIST
(x_train, y_train), (x_test, y_test) = mnist.load_data()
x_train, x_test = x_train / 255.0, x_test / 255.0  # Normalisation

# Créer un modèle simple
model = Sequential([
    Flatten(input_shape=(28, 28)),
    Dense(128, activation='relu'),
    Dense(10, activation='softmax')
])

model.compile(
    optimizer='adam',
    loss='sparse_categorical_crossentropy',
    metrics=['accuracy']
)

# Entraîner le modèle
model.fit(x_train, y_train, epochs=5, validation_split=0.1)

# Évaluer
loss, acc = model.evaluate(x_test, y_test)
print(f'Test accuracy: {acc:.4f}')

# Exporter en .tflite
converter = tf.lite.TFLiteConverter.from_keras_model(model)
tflite_model = converter.convert()

# Sauver dans un fichier
os.makedirs('export', exist_ok=True)
with open('export/mnist.tflite', 'wb') as f:
    f.write(tflite_model)

print("✅ Modèle exporté dans export/mnist.tflite")
