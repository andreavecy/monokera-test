
# 🐇 Monokera Microservices - Event Driven con RabbitMQ y Ruby on Rails

## 📦 Descripción del Proyecto

Este proyecto implementa una arquitectura de microservicios basada en eventos utilizando:

- 🐍 **Ruby on Rails 7 API**
- 🐘 **PostgreSQL**
- 🐇 **RabbitMQ** como broker de eventos

## 🏗️ Microservicios Implementados

- **Customer Service:** Gestión de clientes
- **Order Service:** Gestión de órdenes

Ambos se comunican de forma **asíncrona mediante RabbitMQ**.

---

## 🚀 Levantamiento del Proyecto

### 🔥 Clonar el repositorio

```bash
git clone <repo_url>
cd monokera_test
```

### 🔥 Levantar los servicios

```bash
docker-compose up --build
```

### ✅ Servicios disponibles

| Servicio           | URL                    |
|--------------------|------------------------|
| RabbitMQ Dashboard | http://localhost:15672 |
| Customer API       | http://localhost:3001  |
| Order API          | http://localhost:3002  |

🔐 RabbitMQ Credenciales:  
User: `guest`  
Password: `guest`

---

## 🔗 Ejecución de Consumers (Escucha de eventos)

### 🟦 Escuchar órdenes en Customer Service

```bash
 docker compose run --rm --entrypoint="" customer_service bundle exec ruby lib/rabbitmq/order_consumer.rb
```

### 🟩 Escuchar clientes en Order Service

```bash
docker compose run --rm --entrypoint="" order_service bundle exec ruby lib/rabbitmq/customer_consumer.rb
```

---

## 🐇 Estructura de Eventos

### Evento: `customer_created`

```json
{
  "id": 1,
  "name": "Andrea Vecino",
  "email": "andrea@example.com",
  "phone": "3001234567",
  "address": "Calle 123"
}
```

- Emitido por: **Customer Service**
- Consumido por: **Order Service**

---

### Evento: `order_created`

```json
{
  "id": 5,
  "customer_id": 1,
  "status": "pending",
  "total": 12000,
  "items": [
    {
      "id": 1,
      "product_name": "Hamburguesa",
      "quantity": 2,
      "price": 5000
    },
    {
      "id": 2,
      "product_name": "Gaseosa",
      "quantity": 1,
      "price": 2000
    }
  ]
}
```

- Emitido por: **Order Service**
- Consumido por: **Customer Service**

---

## 🎯 Endpoints REST

### 🔸 Customer Service

| Método | Endpoint            | Descripción              |
|--------|----------------------|--------------------------|
| GET    | `/customers`         | Listar clientes          |
| GET    | `/customers/:id`     | Ver cliente              |
| POST   | `/customers`         | Crear cliente *(emite evento)* |
| PUT    | `/customers/:id`     | Actualizar cliente       |
| DELETE | `/customers/:id`     | Eliminar cliente         |

**Ejemplo POST:**

```json
POST http://localhost:3001/customers
{
  "customer": {
    "name": "Andrea Vecino",
    "email": "andrea@example.com",
    "phone": "3001234567",
    "address": "Calle 123"
  }
}
```

---

### 🔸 Order Service

| Método | Endpoint          | Descripción              |
|--------|--------------------|--------------------------|
| GET    | `/orders`          | Listar órdenes           |
| GET    | `/orders/:id`      | Ver orden                |
| POST   | `/orders`          | Crear orden *(emite evento)* |
| PUT    | `/orders/:id`      | Actualizar orden         |
| DELETE | `/orders/:id`      | Eliminar orden           |

**Ejemplo POST:**

```json
POST http://localhost:3002/orders
{
  "order": {
    "customer_id": 1,
    "status": "pending",
    "total": 12000,
    "order_items_attributes": [
      {
        "product_name": "Hamburguesa",
        "quantity": 2,
        "price": 5000
      },
      {
        "product_name": "Gaseosa",
        "quantity": 1,
        "price": 2000
      }
    ]
  }
}
```

---

## HTTP Client entre servicios

El archivo `lib/http/customer_client.rb` en `order_service` consulta el `customer_service` por ID.

**Uso**:

```ruby
CustomerClient.find_customer(1)
```

Este cliente HTTP se utiliza en `OrdersController#show` para mostrar información del cliente en la respuesta.

---

## Validaciones implementadas

- No se permite crear una orden si el cliente no existe.
- Se incluye el cliente en la respuesta del `GET /orders/:id`

---

## Variables de entorno

Ya incluidas en `docker-compose.yml`:

```yaml
- CUSTOMER_SERVICE_URL=http://customer_service:3000
```


---

## Observaciones

- La comunicación HTTP usa el hostname del servicio Docker (`customer_service`) y no `localhost`
- Asegúrate de ejecutar `rails db:create db:migrate` para cada servicio si hay cambios
- Puedes ver los logs con `docker compose logs -f order_service`

---

## ⚙️ Estructura RabbitMQ

✔ Publisher:  
`lib/rabbitmq/publisher.rb`  
→ Maneja la publicación de eventos a RabbitMQ con reconexión, colas durables y manejo simple desde cualquier modelo.

✔ Consumers:  
→ Scripts ejecutables ubicados en:  
- `lib/rabbitmq/customer_consumer.rb`  
- `lib/rabbitmq/order_consumer.rb`  

✔ Publisher específicos:  
→ `customer_publisher.rb` y `order_publisher.rb` encapsulan los datos para los eventos respectivos.

---

## 🏗️ Diagrama de Arquitectura

```
                             +--------------------+
                             |   RabbitMQ Broker   |
                             +----------+----------+
                                        | 
                  +---------------------+----------------------+
                  |                                            |
      +---------------------------+              +---------------------------+
      |   Customer Microservice    |              |    Order Microservice     |
      +---------------------------+              +---------------------------+
      | - API REST (CRUD)         |              | - API REST (CRUD)         |
      | - Publica: customer_created| ---> Evento | - Escucha: customer_created|
      | - Escucha: order_created   | <--- Evento | - Publica: order_created   |
      +---------------------------+              +---------------------------+
```

---

## 🧪 ✅ Ejecución de Pruebas Automatizadas

### 🔥Ejecutar pruebas

```bash
docker compose -f docker-compose.test.yml up --build --abort-on-container-exit
```

---

## 👩‍💻 Autor

**Andrea Vecino**  
Desarrolladora Ruby on Rails | Arquitectura de Software | Microservicios  

---

## 🚀 Conclusión

Este proyecto es un ejemplo funcional de arquitectura orientada a eventos con RabbitMQ, implementando desacoplamiento total entre microservicios con Rails, PostgreSQL y comunicación asíncrona.

---
