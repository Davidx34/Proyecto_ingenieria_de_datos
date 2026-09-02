# Plan de pruebas — Proyecto Liwi Flor Eterna

## Objetivo

Verificar que la solución híbrida (MySQL + MongoDB) y el tablero de Power BI
cumplen los requisitos funcionales de los cuatro módulos y las cinco historias de
usuario definidas en el Entregable 1.

## Alcance

| Módulo | Responsable | Qué se prueba |
|--------|-------------|---------------|
| Módulo 1: Gestión de Clientes y Pedidos | José David | Scripts DDL/DML, vistas, procedimientos y triggers del área de clientes y pedidos |
| Módulo 2: Gestión de Productos e Inventario | Jhonatan | Scripts DDL/DML, control de inventario y movimientos de stock |
| Módulo 3: Usuarios y Seguridad | Antoine | Gestión de usuarios, roles y permisos |
| Módulo 4: Analítica y Visualización | Equipo | Integración de datos y métricas de rentabilidad en Power BI |

## Tipos de prueba

- **Pruebas de esquema:** las tablas se crean con sus PK y FK; las restricciones
  rechazan datos inválidos.
- **Pruebas de carga (DML):** cada tabla queda con un mínimo de 50 registros
  coherentes.
- **Pruebas funcionales:** un caso de prueba por historia de usuario, derivado de sus
  escenarios Gherkin (ver `casos_de_prueba/`).
- **Pruebas de integración:** el conector de Node.js lee y escribe en MongoDB; los
  datos de los módulos 1–3 alimentan correctamente el tablero del módulo 4.

## Casos de prueba por historia de usuario

Cada archivo en `casos_de_prueba/` corresponde a una historia de usuario del
Entregable 1 y traduce sus escenarios Gherkin a pasos ejecutables con resultado
esperado:

| Requisito | Archivo |
|-----------|---------|
| RQF-035 | `casos_de_prueba/RQF-035.md` |
| RQF-034 | `casos_de_prueba/RQF-034.md` |
| RQF-033 | `casos_de_prueba/RQF-033.md` |
| RQF-006 | `casos_de_prueba/RQF-006.md` |
| RQF-025 | `casos_de_prueba/RQF-025.md` |

## Criterio de aceptación

Una funcionalidad se da por aprobada cuando todos los escenarios de su caso de prueba
pasan y el script asociado corre sin errores en un entorno local limpio.
