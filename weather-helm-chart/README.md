<div style="text-align: justify;">

# HELM CHART

Estos helm chart son una forma de despliegue más robusta que los manifiestos que se utilizan por medio de kubectl, por medio de helm podemos realizar release con los cuales nos podemos basar como punto de guaradado a tal punto que si hay algun problema podemos realizar un rollback rápido sin perder disponibilidad del aplicativo, si sumamos esto al uso de la bandera atomic la cual valida como en el principio ACID de que todo el despliegue este en marcha, sino hace un roll back, automatico.

Como se usan los helm chart, hay varios pasos primero verificar la integridad de los mismos con un `helm lint /ubicacion/chart/weather-helm-chart  --values /ubicacion/chart/weather-helm-chart/values.yaml` con el cual podemos validar la integridad de los charts `helm template /ubicacion/chart/weather-helm-chart  --values /ubicacion/chart/weather-helm-chart/values.yaml` con el cual renderizamos los charts para poder visualizar los datos remplazados y finalmente   `helm upgrade weather-release /ubicacion/chart/weather-helm-chart  --values /ubicacion/chart//weather-helm-chart/values.yaml --install` El cual nos permite instalar el despliegue o actualizarlo ademas de contener lo anteriormente comentado de atomic

</div>
