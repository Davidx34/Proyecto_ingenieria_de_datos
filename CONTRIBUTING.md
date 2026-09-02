# Guía de contribución

Flujo de trabajo del equipo para el Proyecto de Ingeniería de Datos de Liwi Flor Eterna.

## Ramas

- La rama `main` siempre debe quedar en un estado funcional. **Nadie hace commit
  directo a `main`.**
- Cada integrante trabaja en su rama individual:

  | Integrante  | Rama                 |
  |-------------|----------------------|
  | Antoine     | `feature/antoine`    |
  | José David  | `feature/jose-david` |
  | Jhonatan    | `feature/jhonatan`   |

- Para tareas puntuales se pueden crear sub-ramas a partir de la rama individual
  (por ejemplo `feature/jose-david-tabla-cliente`), pero la integración a `main`
  siempre pasa por la rama del integrante.

## Revisión de código

- Antes de fusionar cualquier cambio a `main`, **otro integrante distinto de quien
  escribió el código debe revisarlo**. Esto corresponde a la columna **"En revisión"**
  del tablero Kanban del equipo.
- La revisión se hace mediante Pull Request hacia `main`. El PR no se fusiona hasta
  tener la aprobación del revisor.

## Convención de commits

- Mensajes **cortos, en español y en infinitivo**.
- Ejemplos:
  - `agregar script DDL de tabla Cliente`
  - `corregir cardinalidad en MER`
  - `agregar 50 registros de carga a tabla Pedido`
  - `documentar acta de reunión del 5 de septiembre`

## Verificación antes del merge

- Antes de hacer merge a `main`, verificar que el script SQL o NoSQL **corra sin
  errores localmente** (PostgreSQL, Mongo Shell o el conector de Node.js, según
  corresponda).
- Si el cambio es de documentación o diagramas, verificar que el `.tex` compile y que
  las imágenes exportadas estén actualizadas.
