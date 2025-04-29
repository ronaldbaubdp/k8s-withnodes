### Instalacion de Pandoc 

Visite la pagina oficial de Pandoc para poder descargar el instalador de Pandoc en windows

https://pandoc.org/installing.html

Una ves descaragado instale el ejecutable, y pruebe en la consola de powershell (Windows):

```bash
pandoc --version
```

Luego instale Latex desde la página oficial de Latex:

https://miktex.org/download


Luego abra la aplicacion `MikTex Console` en Windows.

En la opción de Updates, busque la `Check Updates` necesariasuna vez listado las actualizaciones disponibles proceda a instalarlas con `Upadte Now`.

Una vez realizado esto, ya puede utiliza pandadoc en Windows para elaborar documentacion con Latex incluido.

Ejemplo de comando para crear el archivo .pdf
```bash
pandoc miarchivo.md -o output/miarchivo.pdf
```

Ahora, personalice cada una de las configuraciones necesarias para elaborar su documento.

---
> Autor: *Ronald Bautista*
> 
> Versión: *1.0*