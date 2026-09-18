# Arquitectura de Computadoras | GR20

Repositorio oficial para el curso de Arquitectura de Computadoras (GR20).

## 👥 Integrantes

| Nombre Completo | Carné | Usuario de GitHub |
| :--- | :---: | :---: |
| **Luis Pablo Vargas Muñoz** | `2021490483` | [@SkyVM888](https://github.com/SkyVM888) |
| **Carlos Daniel Hurtado Villalobos** | `2021-------` | [@Charlespixel](https://github.com/Charlespixel) |
| **Brayan Ariel Vargas Rojas** | `2021028522` | [@BrayanVR21](https://github.com/BrayanVR21) |

## 📌 Descripción del Proyecto

Programa en ensamblador x86 (modo real de 16 bits) que procesa varios de arreglos de enteros de 8 bits con signo para calcular la suma total, el valor mínimo, el valor máximo y la cantidad de elementos estrictamente mayores que un umbral determinado $T$, validando que la dimensión $N$ de cada arreglo cumpla la condición $1 \le N \le 64$.

## 🛠️ Herramientas y Tecnologías

* **Ensamblador:** x86 (TASM - Turbo Assembler)
* **Entorno de Ejecución:** DOSBox
* **Control de Versiones:** GitHub

## ⚙️ Modificación de Arreglos, Dimensiones ($N$) y Umbrales ($T$)

Las modificaciones de los datos de entrada se realizan directamente en el archivo `main.asm` dentro de la sección de datos (`.data`):

1. **Ubicación:** Abrir `main.asm` e ir a la sección `.data`.
2. **Dimensiones ($N$):** Modificar la etiqueta `N DW ...` asignando un valor de 16 bits por cada arreglo correspondiente.
3. **Umbrales ($T$):** Modificar la etiqueta `T DB ...` asignando un valor de 8 bits con signo para la comparación de cada arreglo correspondiente.
4. **Cantidad de arreglos:** Si se agregan o eliminan arreglos, ajustar la constante `Cantidad EQU ...`.
5. **Definición de arreglos y matriz:** Definir las variables `arreglo1`, `arreglo2`, ..., `arregloN` con sus respectivos elementos de tipo `DB` y registrar sus direcciones en el vector `Matriz DW OFFSET arreglo1, OFFSET arreglo2, ...`.

```assembly
.data
    ; Ejemplo de configuración en test.asm:
    N           DW  8, 1, 4, 4, 64, 64            ; Dimensiones N (16 bits)
    T           DB  5, -7, -5, 5, 126, -128       ; Umbrales T (8 bits con signo)
    Cantidad    EQU 6                             ; Total de arreglos a procesar

    arreglo1    DB  -12, 0, 18, -5, 127, -128, 18, 5
    ; ...
    Matriz      DW  OFFSET arreglo1, OFFSET arreglo2, ...