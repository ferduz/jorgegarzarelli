#!/bin/bash

# Script para agregar el archivo CSS personalizado a todas las páginas HTML del sitio
# Este script oculta los iconos SVG molestos en todo el sitio

echo "🔧 Actualizando todas las páginas HTML para incluir custom-fixes.css..."

# Contador de archivos procesados
count=0

# Buscar todos los archivos HTML y procesarlos
find /home/fernandoduzdevich/jorgegarzarelli -name "*.html" -type f | while read file; do
    # Calcular la ruta relativa al archivo CSS basada en la profundidad del directorio
    depth=$(echo "$file" | sed 's|/home/fernandoduzdevich/jorgegarzarelli/||' | tr -cd '/' | wc -c)
    
    # Crear la ruta relativa correcta
    if [ $depth -eq 0 ]; then
        css_path="wp-content/custom-fixes.css"
    elif [ $depth -eq 1 ]; then
        css_path="../wp-content/custom-fixes.css"
    elif [ $depth -eq 2 ]; then
        css_path="../../wp-content/custom-fixes.css"
    elif [ $depth -eq 3 ]; then
        css_path="../../../wp-content/custom-fixes.css"
    elif [ $depth -eq 4 ]; then
        css_path="../../../../wp-content/custom-fixes.css"
    else
        css_path="../../../../../wp-content/custom-fixes.css"
    fi
    
    # Verificar si el archivo ya contiene nuestro CSS personalizado
    if ! grep -q "custom-fixes.css" "$file"; then
        # Buscar la línea del CSS del tema twentyseventeen y agregar nuestro CSS después
        if grep -q "twentyseventeen/style.css" "$file"; then
            # Crear archivo temporal
            temp_file=$(mktemp)
            
            # Agregar nuestro CSS después del CSS del tema
            sed "/twentyseventeen\/style.css/a\\
<link rel=\"stylesheet\" href=\"$css_path\" type=\"text/css\" media=\"all\">" "$file" > "$temp_file"
            
            # Reemplazar el archivo original
            mv "$temp_file" "$file"
            
            count=$((count + 1))
            echo "✅ Actualizado: $file"
        fi
    else
        echo "⏭️  Ya actualizado: $file"
    fi
done

echo "🎉 ¡Completado! Se actualizaron $count archivos HTML."
echo "💡 Los iconos SVG ahora estarán ocultos en todo el sitio web."
