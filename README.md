# Proyecto de Ingeniería de Datos — Liwi Flor Eterna

Solución híbrida de base de datos (MySQL + MongoDB) con un tablero de control en
Power BI para analizar la rentabilidad de la empresa **Liwi Flor Eterna**. El sistema
integra la gestión operativa (clientes, pedidos, productos, inventario, usuarios y
seguridad) con una capa analítica que consolida los datos de los tres módulos
transaccionales para la toma de decisiones.

## Cliente

**Liwi Flor Eterna**

## Integrantes y módulos

| Integrante  | Módulo                                       |
|-------------|----------------------------------------------|
| Antoine     | Módulo 3: Usuarios y Seguridad               |
| José David  | Módulo 1: Gestión de Clientes y Pedidos      |
| Jhonatan    | Módulo 2: Gestión de Productos e Inventario  |

El **Módulo 4: Analítica y Visualización** (tablero de Power BI) se trabaja entre los
tres integrantes porque integra el resultado de los otros tres módulos.

## Estructura de carpetas

```
Proyecto_ingenieria_de_datos/
├── README.md                 # Este archivo
├── CONTRIBUTING.md            # Flujo de trabajo del equipo (ramas, revisión, commits)
├── .gitignore
├── docs/
│   ├── entregables/          # Documentos formales del proyecto (.tex y .pdf compilado)
│   ├── diagramas/
│   │   ├── fuente/           # Archivos .tex de cada diagrama (MER, MR, clases, stakeholders, kanban, flujos)
│   │   └── imagenes/         # Diagramas exportados a .png
│   └── actas/                # Actas de reunión con el cliente
├── sql/
│   ├── ddl/                  # 01_DDL.sql: tablas, restricciones, vistas, funciones y procedimientos
│   ├── dml/                  # 02_DML.sql: carga de datos y creación de los triggers
│   ├── consultas/            # 03_Consultas_E2.sql: consultas de evidencia
│   ├── vistas/               # 10 vistas vw_*, una por archivo
│   ├── procedimientos/       # 2 funciones fn_* y 12 procedimientos sp_*, uno por archivo
│   └── triggers/             # 7 triggers trg_*, uno por archivo
├── nosql/
│   ├── scripts/              # Scripts de Mongo Shell
│   └── node-connector/       # Proyecto Node.js de conexión a MongoDB
├── bi/                       # Archivos .pbix y capturas del tablero de Power BI
└── tests/
    ├── plan_de_pruebas.md    # Plan de pruebas: 29 casos con resultado esperado
    └── casos_de_prueba/      # Ejecución de los 65 requisitos funcionales, salida esperada y capturas
```

## Base de datos relacional (Entregable 2)

La base `liwi_flor_eterna` (MySQL 8, probada también en MariaDB 10.11) tiene 21 tablas,
10 vistas, 2 funciones, 12 procedimientos y 7 triggers. El inventario queda fuera del
alcance de esta entrega.

### Cómo montarla

Con estos dos scripts, en este orden, la base queda completa:

```bash
mysql -u root -p --default-character-set=utf8mb4 < sql/ddl/01_DDL.sql
mysql -u root -p --default-character-set=utf8mb4 < sql/dml/02_DML.sql
```

1. `01_DDL.sql` crea la base, las tablas, las vistas, las funciones y los procedimientos.
2. `02_DML.sql` carga los datos y, al final, crea los triggers (van al final para que la
   carga no los dispare).

Las carpetas `vistas/`, `procedimientos/` y `triggers/` contienen la misma lógica separada
en un archivo por objeto, para leerla con más facilidad. Cada archivo se puede ejecutar
solo (empieza con `use liwi_flor_eterna;`).

### Datos

- 500 ventas, 619 líneas de venta y 500 gastos.
- Solo 96 ventas (122 líneas) y 110 gastos son reales (15 de agosto a 15 de septiembre
  de 2026). El resto es simulado hasta el 31 de enero de 2027, para dar volumen a las
  consultas y a los cierres.
- 208 líneas de venta tienen el precio pendiente: el cliente aún no confirma esos
  valores, por eso no se inventaron.
- No todas las tablas llegan a 50 registros: las tablas de catálogo y configuración
  tienen pocos datos reales, y el informe lo justifica.

### Pruebas

- `tests/plan_de_pruebas.md`: 29 casos con resultado esperado.
- `tests/casos_de_prueba/04_Ejecucion_65_RF.sql`: ejecuta y explica los 65 requisitos
  funcionales. `04_Ejecucion_65_RF_simple.sql` hace lo mismo con sentencias directas.
- `tests/casos_de_prueba/05_Invocar_RF.sql`: invoca cada requisito con `call sp_rf_NN();`.
- `tests/casos_de_prueba/Salida_esperada_65_RF.*`: resultado esperado de cada requisito.
- `tests/casos_de_prueba/capturas/`: capturas en MySQL Workbench y DBeaver.

Las contraseñas se guardan como hash SHA-256. Los usuarios de prueba usan la contraseña
`Liwi#<id>` (por ejemplo, el socio con id 1 usa `Liwi#1`).

## Stack tecnológico

- **MySQL** — base de datos relacional para los datos transaccionales.
- **MongoDB** — base de datos documental para la parte no relacional de la solución híbrida.
- **Node.js** — conector de aplicación hacia MongoDB.
- **Power BI** — tablero de control para la analítica de rentabilidad (Módulo 4).

## Documentación formal

La documentación formal del proyecto (contextualización, pregunta problema, objetivos,
alcance, metodología, propuesta de solución, requisitos, historias de usuario,
stakeholders y modelos de datos) vive en [`docs/entregables/`](docs/entregables/).

## Estado actual

**Entregable 1 completado. Entregable 2 (diseño lógico, físico e implementación
relacional) entregado.** Siguiente: capa no relacional y tablero de control.

#### Cómo clonar

```bash
git clone https://github.com/Davidx34/Proyecto_ingenieria_de_datos.git
cd Proyecto_ingenieria_de_datos
```
#### Tablero trello
https://trello.com/invite/b/6a8651745f0058c3379d8943/ATTId67b1221493ec3d7402afdb95ae2ede59327D92A/proyecto-liwi-flor-eterna
