# Arquitectura de Computadoras | GR20

Repositorio oficial para el curso de Arquitectura de Computadoras (GR20).

## 👥 Integrantes

| Nombre Completo | Carné | Usuario de GitHub |
| :--- | :---: | :---: |
| **Luis Pablo Vargas Muñoz** | `2021490483` | [@SkyVM888](https://github.com/SkyVM888) |
| **Carlos Daniel Hurtado Villalobos** | `2021067615` | [@Charlespixel](https://github.com/Charlespixel) |
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
    N           DW  8, 1, 4, 4, 64, 64, 0, 65         ; Dimensiones N (16 bits)
    T           DB  5, -7, -5, 5, 126, -128, 1, 1     ; Umbrales T (8 bits con signo)
    Cantidad    EQU 8                                 ; Total de arreglos a procesar

    arreglo1    DB  -12, 0, 18, -5, 127, -128, 18, 5
    ; ...
    Matriz      DW  OFFSET arreglo1, OFFSET arreglo2, ...
```

# Guía de Compilación y Ejecución (x86 Assembly - TASM)

---

## 📌 Requisitos Previos

- **Archivo a procesar:** `main.asm` (En simulador se cambia automaticamente a `test.asm`)
- **Entorno de simulación:** DOSBox o entorno compatible con DOS de 16 bits.
- **Herramientas de desarrollo:** Turbo Assembler (`TASM.EXE`) y Turbo Linker (`TLINK.EXE`).

---

## 🛠️ Opciones de Ejecución

### Opción 1: Ejecución Automática en Visual Studio Code (`Run ASM code`)

Este método utiliza la extensión **MASM/TASM** integrada en VS Code para realizar la compilación, el enlace y la ejecución de manera automática dentro de DOSBox.

1. Abra **Visual Studio Code**.
2. Abra la carpeta del proyecto y seleccione el archivo `main.asm`.
3. Haga clic derecho sobre la ventana de edición del archivo `main.asm`.
4. Seleccione la opción **Run ASM code** en el menú contextual (o use la combinación de teclas rápida si la tiene configurada).
5. La extensión iniciará DOSBox, compilará el archivo, generará el ejecutable y mostrará los resultados directamente en la consola.

---

### Opción 2: Compilación y Ejecución Manual (Línea de Comandos / DOSBox)

Este método permite ensamblar, enlazar y ejecutar manualmente el programa desde la consola de comandos de DOSBox.

#### 1. Abrir emulador DOSBox en VS Code
1. Haga clic derecho sobre la ventana de edición del archivo `main.asm`.
2. Seleccione la opción **Open Emulator** en el menú contextual (o use la combinación de teclas rápida si la tiene configurada).

#### 2. Ensamblado
Genera el archivo objeto (`test.obj`) a partir del archivo de código fuente:
```cmd
TASM test.asm
```
#### 3. Enlace
Enlaza el archivo objeto para generar el ejecutable (`test.exe`):
```cmd
TLINK test.obj
```
#### 4. Ejecución
Ejecute el programa generado en la consola:
```cmd
test
```

## 📊 Resultados Esperados

Al ejecutar el programa, se mostrarán en pantalla las siguientes métricas calculadas sobre los datos de los arreglos:
- Arreglos: Numero del arreglo evaluado.
- N: Dimensión del arreglo evaluado.
- T: Umbral de comparación (8 bits con signo).
- Mín: Valor mínimo encontrado en el arreglo.
- Máx: Valor máximo encontrado en el arreglo.
- Suma: Suma total de los elementos.
- Conteo_C: Cantidad de elementos estrictamente mayores al umbral $T$.

En caso de no cumplir con la condición $1 \le N \le 64$, el arreglo correspondiente a dicho N no será evaluado y se indicará `ERROR` como resultado.


## 📌 Datos de la Entrega Final

- **Repositorio:** [ADC1-P1-Grupo-PCB](https://github.com/SkyVM888/ADC1-P1-Grupo-PCB)
- **Nombre de la Etiqueta (Tag):** `P1-Entrega`
- **Identificador del Commit (Hash):** `09d7487`
- **Enlace a la Release/Tag:** [Ver Release P1-Entrega en GitHub](https://github.com/SkyVM888/ADC1-P1-Grupo-PCB/releases/tag/P1-Entrega)
