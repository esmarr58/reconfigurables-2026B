module clockgenerico #(parameter[24:0] limite=0)(fin, fout);

input fin;
output reg fout=0;
reg [24:0] contador=0;
always @(posedge fin)
begin
if(contador==limite)
begin
contador<=0;
fou t<= ~fout;
end
else
contador<=contador+1;

end
endmodule
