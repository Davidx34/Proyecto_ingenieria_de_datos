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
│   ├── ddl/                  # Scripts CREATE TABLE, definición de PK y FK
│   ├── dml/                  # Scripts INSERT de carga (mínimo 50 registros por tabla)
│   ├── vistas/               # Definición de vistas
│   ├── procedimientos/       # Procedimientos almacenados
│   └── triggers/             # Disparadores
├── nosql/
│   ├── scripts/              # Scripts de Mongo Shell
│   └── node-connector/       # Proyecto Node.js de conexión a MongoDB
├── bi/                       # Archivos .pbix y capturas del tablero de Power BI
└── tests/
    ├── plan_de_pruebas.md    # Estrategia y alcance de las pruebas
    └── casos_de_prueba/      # Un archivo por historia de usuario, derivado de sus escenarios Gherkin
```

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

**Entregable 1 completado.** En desarrollo: Entregable 2 (diseño lógico y físico,
implementación relacional).

#### Cómo clonar

```bash
git clone https://github.com/Davidx34/Proyecto_ingenieria_de_datos.git
cd Proyecto_ingenieria_de_datos
```
#### Tablero trello
https://trello.com/b/IBj40svK
