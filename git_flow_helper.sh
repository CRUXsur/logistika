#!/bin/bash

# Función para mostrar el menú
show_menu() {
    echo ""
    echo "=== Git Flow Helper ==="
    echo "1. Crear rama feature/"
    echo "2. Crear rama bugfix/"
    echo "3. Crear rama hotfix/"
    echo "4. Crear rama release/"
    echo "5. Volver a developer"
    echo "6. Volver a main"
    echo "7. Salir"
    echo ""
}

# Función para crear una nueva rama
create_branch() {
    read -p "Nombre de la rama: " branch_name
    full_branch="$1/$branch_name"
    git checkout -b "$full_branch"
    echo "✅ Rama creada: $full_branch"
}

# Loop del menú
while true; do
    show_menu
    read -p "Selecciona una opción [1-7]: " choice

    case $choice in
        1) create_branch "feature" ;;
        2) create_branch "bugfix" ;;
        3) create_branch "hotfix" ;;
        4) create_branch "release" ;;
        5) git checkout developer && echo "✔️ Cambiado a developer" ;;
        6) git checkout main && echo "✔️ Cambiado a main" ;;
        7) echo "👋 ¡Listo!"; break ;;
        *) echo "❌ Opción inválida." ;;
    esac
done