/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package modeloqytetet;

/**
 *
 * @author sofiafernandezmoreno
 */
public class TituloPropiedad {

    private String nombre;
    private Boolean hipotecada;
    private int precioCompra;
    private int alquilerBase;
    private float factorRevalorizacion;
    private int hipotecaBase;
    private int precioEdificar;
    private int numHoteles;
    private int numCasas;
    private Jugador propietario;

    public TituloPropiedad(String nombre, int precioCompra, int alquilerBase, float factorRevalorizacion, int hipotecaBase, int precioEdificar) {
        this.nombre = nombre;
        this.hipotecada = false;
        this.precioCompra = precioCompra;

        this.numHoteles = 0;
        this.numCasas = 0;
        this.propietario = null;

        this.nombre = nombre;
        if (alquilerBase > 50 && alquilerBase < 100) {
            this.alquilerBase = alquilerBase;
        }
        if (factorRevalorizacion > (0.1) && factorRevalorizacion < (0.2)) {
            this.factorRevalorizacion = factorRevalorizacion;
        }

        this.hipotecaBase = hipotecaBase;
        if (precioEdificar > 250 && precioEdificar < 750) {
            this.precioEdificar = precioEdificar;
        }

        if (hipotecaBase > 150 && hipotecaBase < 1000) {
            this.hipotecaBase = hipotecaBase;
        }
    }

    public String getNombre() {
        return nombre;
    }

    public Boolean getHipotecada() {
        return hipotecada;
    }

    public int getPrecioCompra() {
        return precioCompra;
    }

    public int getAlquilerBase() {
        return alquilerBase;
    }

    public float getFactorRevalorización() {
        return factorRevalorizacion;
    }

    public int getHipotecaBase() {
        return hipotecaBase;
    }

    public int getPrecioEdificar() {
        return precioEdificar;
    }

    public int getNumHoteles() {
        return numHoteles;
    }

    public int getNumCasas() {
        return numCasas;
    }

    public void setHipotecada(Boolean hipotecada) {
        this.hipotecada = hipotecada;
    }

    public float getFactorRevalorizacion() {
        return factorRevalorizacion;
    }

    public void setFactorRevalorizacion(float factorRevalorizacion) {
        this.factorRevalorizacion = factorRevalorizacion;
    }

    Jugador getPropietario() {
        return propietario;
    }

    void setPropietario(Jugador jugador) {
        this.propietario = jugador;
    }

    @Override
    public String toString() {
        return "TituloPropiedad{" + "nombre=" + nombre + ", hipotecada=" + hipotecada + ", precioCompra=" + precioCompra + ", alquilerBase=" + alquilerBase + ", factorRevalorizacion=" + factorRevalorizacion + ", hipotecaBase=" + hipotecaBase + ", precioEdificar=" + precioEdificar + ", numHoteles=" + numHoteles + ", numCasas=" + numCasas + '}';
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public void setPrecioCompra(int precioCompra) {
        this.precioCompra = precioCompra;
    }

    public void setAlquilerBase(int alquilerBase) {
        this.alquilerBase = alquilerBase;
    }

    public void setHipotecaBase(int hipotecaBase) {
        this.hipotecaBase = hipotecaBase;
    }

    public void setPrecioEdificar(int precioEdificar) {
        this.precioEdificar = precioEdificar;
    }

    public void setNumHoteles(int numHoteles) {
        this.numHoteles = numHoteles;
    }

    public void setNumCasas(int numCasas) {
        this.numCasas = numCasas;
    }

    boolean tengoPropietario() {
        boolean aux = false;
        if (this.propietario != null) {
            aux = true;
        }
        return aux;
    }

    boolean propietarioEncarcelado() {
        boolean aux = false;
        if (propietario.getEncarcelado() == true) {
            aux = true;
        }
        return aux;
    }

    int calcularImporteAlquiler() {
        int costeAlquiler = alquilerBase + (int)(numCasas*0.5+numHoteles*2);
        return costeAlquiler;

    }

    int pagarAlquiler() {
        //
        int costeAlquiler = calcularImporteAlquiler();
        propietario.modificarSaldo(costeAlquiler);
        return costeAlquiler;
    }
    int calcularCosteHipoteca(){
        return hipotecaBase + (numCasas*(int)(0.5)*hipotecaBase) + numHoteles*hipotecaBase;
    }
    int calcularCosteCancelar(){
        int costeCancelar = calcularCosteHipoteca();
        costeCancelar = costeCancelar + (costeCancelar * (int)0.1);
        return costeCancelar;
    }
    int hipotecar(){
        //3.1.1
        setHipotecada(true);
        //3.1.2
        int costeHipoteca = calcularCosteHipoteca();
        return costeHipoteca;
    }
    
    int calcularPrecioVenta(){
        int precioVenta = precioCompra +(numCasas+numHoteles)*precioEdificar*(int)factorRevalorizacion;
        return precioVenta;
    
    }
    
    void edificarCasa(){    
        this.setNumCasas(this.numCasas + 1);    
    }
    void edificarHotel(){    
        this.setNumHoteles(this.numHoteles + 1);    
    }
    void cancelarHipoteca(){
        hipotecada = false;    
    }
    
    
    
    

}
