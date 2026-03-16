---
title: "Final Relic"
type: "Juego Móvil Indie (Action RPG)"
status: "En Desarrollo / Listo para Producción"
tech_stack: ["Flutter", "Dart", "Bonfire Engine", "Firebase", "AdMob"]
role: "Game Developer & Mobile Engineer"
github_url: "https://github.com/jnthn-uribe/final-game"
live_url: ""
image_cover: "/assets/projects/final-relic-cover.jpg"
---

## Descripción Corta (Elevator Pitch)
Final Relic es un cautivador juego móvil RPG de acción y exploración de mazmorras con estética retro (pixel art). Su principal diferenciador es lograr un rendimiento fluido multiplataforma en iOS y Android utilizando Flutter, ofreciendo un sistema completo de progreso de jugador, mecánicas de combate dinámicas y sincronización en la nube en tiempo real.

## El Problema y la Solución
Desarrollar juegos indie multiplataforma 2D de alto rendimiento convencionalmente requiere mantener múltiples bases de código o utilizar motores pesados que penalizan el tamaño y rendimiento de la App. 
**Final Relic soluciona este problema** al apalancar la versatilidad de **Flutter** junto al motor de físicas **Bonfire**, demostrando una alternativa viable, escalable y moderna. Esto permite mantener una sola base de código para lógicas complejas de RPG (físicas, inteligencia artificial de enemigos, animaciones), reduciendo el tiempo de desarrollo sin sacrificar la experiencia a 60 FPS del usuario final.

## Mi Rol y Arquitectura
Diseñé e implementé toda la arquitectura del juego desde cero utilizando **Flutter** y **Dart**. A nivel de cliente, utilicé el motor **Bonfire** para gestionar el «Game Loop», colisiones, estados de animaciones (spritesheets), e interacciones de NPCs.
Para el backend, implementé una arquitectura serverless con **Firebase** integrado de forma nativa. Diseñé un flujo avanzado de autenticación de múltiples pasos (incluyendo manejo de Sesiones de Invitado/Ghost con enlace posterior de cuentas) y utilicé **Firestore** para la sincronización cruzada del progreso del jugador. Finalmente, integre pasarelas y servicios como **Google Mobile Ads** y **PayPal** para el sistema económico del proyecto.

## Características Clave
* **Motor RPG Completo:** Mecánicas avanzadas de combate, interacciones con NPCs, diferentes tier de enemigos (Goblins, Imps, Mini-Bosses, Bosses), loot y diseño de niveles dinámicos.
* **Sistema de Backend con Firebase:** Flujo altamente seguro de inicio de sesión (Guest & Email/Pass) y sincronización de progreso persistente en la nube a través de múltiples dispositivos.
* **Monetización Híbrida Integrada:** Arquitectura lista para e-commerce in-app usando Flutter PayPal Payment y sistema de recompensas/anuncios con Google AdMob.
* **Diseño Arquitectónico Escalable:** Organización del código en módulos lógicos orientada a facilitar la adición futura de nuevas mecánicas, mapas extensos o integraciones de APIs.
