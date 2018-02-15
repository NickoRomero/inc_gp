clear all

use "Z:\Nicolas_Romero\base_SS_nn.dta", clear

keep if ( ciiuc==5211 | ciiuc==5219 | ciiuc==5221 | ciiuc==5222 | ciiuc==5223 | ciiuc==5224 | ///
		ciiuc==5225 | ciiuc==5229 | sectorppal2==5211 | sectorppal2==5219 | sectorppal2==5221 ///
		| sectorppal2==5222 | sectorppal2==5223 | sectorppal2==5224 | sectorppal2==5225 | sectorppal2==5229)

rename v1 caja
rename v7 inversiones
rename v54 activo_corriente
rename v103 activo_no_corriente
rename v104 activo
rename v105 obl_finan
rename v106 proveedores
rename v127 obl_laborales
rename v155 pasivo_corriente
rename v203 pasivo_no_corriente
rename v204 pasivo
rename v227 patrimonio
rename v237 ing_operacionales
rename v238 costo_ventas
rename v239 utilidad_bruta
rename v240 gastos_operacionales_admon
rename v241 gastos_operacionales_ventas
rename v242 utilidad_operacional
rename v243 ingresos_no_operacionales
rename v244 gastos_no_operacionales
rename v245 utilidad_neta
rename v246 ajustes_inflacion
rename v247 impuesto_renta_complementarios
rename v248 beneficios


recast long activo, force
recast long activo_corriente, force
recast long activo_no_corriente, force
recast long caja, force
recast long ing2, force
recast long ing2_def, force
recast long ing_operacionales, force
recast long inversiones, force
recast long obl_finan, force
recast long obl_laborales, force
recast long pasivo, force
recast long pasivo_corriente, force
recast long pasivo_no_corriente, force
recast long patrimonio, force
recast long proveedores, force
recast long sectorppal2, force
recast long costo_ventas, force
recast long utilidad_bruta, force
recast long gastos_operacionales_admon, force
recast long gastos_operacionales_ventas, force
recast long utilidad_operacional, force
recast long ingresos_no_operacionales, force
recast long gastos_no_operacionales, force
recast long utilidad_neta, force
recast long ajustes_inflacion, force
recast long impuesto_renta_complementarios, force
recast long beneficios, force

format  activo %15.0g
format  activo_corriente %15.0g
format  activo_no_corriente %15.0g
format  caja %15.0g
format  ing2 %15.0g
format  ing2_def %15.0g
format  ing_operacionales %15.0g
format  inversiones %15.0g
format  obl_finan %15.0g
format  obl_laborales %15.0g
format  pasivo %15.0g
format  pasivo_corriente %15.0g
format  pasivo_no_corriente %15.0g
format  patrimonio %15.0g
format  proveedores %15.0g
format  sectorppal2 %15.0g
format costo_ventas %15.0g
format utilidad_bruta %15.0g
format gastos_operacionales_admon %15.0g
format gastos_operacionales_ventas %15.0g
format utilidad_operacional %15.0g
format ingresos_no_operacionales %15.0g
format gastos_no_operacionales %15.0g
format utilidad_neta %15.0g
format ajustes_inflacion %15.0g
format impuesto_renta_complementarios %15.0g
format  beneficios %15.0g


export delimited using "D:\Borrador Gasolina\SuperSociedades_G52.csv", datafmt replace
