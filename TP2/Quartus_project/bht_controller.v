/* BHT and BTB Controller (Branch History Table AND Branch Table Buffer) 

Ambas tablas se acceden de la misma manera, por lo que se unen en un
mismo módulo RAM (64 filas y 32 bits por fila).

Se accede por PC_FETCH y la salida es su PC_TARGET asociado.

*/

module bht_controller(
	// pc_fetch: PC a leer
	input wire [10:0] pc_fetch;
	
	// pc_fetch_update: PC a modificar su PC TARGET asociado.
	input wire [10:0] pc_fetch_update;
	// pc_target_update: PC TARGET a guardar.
	input wire [10:0] pc_target_update;
	
	input wire clk;
	
	// pc_target_prediction: PC TARGET leído.
	output reg [10:0] pc_target_prediction,
	output reg hit
)


