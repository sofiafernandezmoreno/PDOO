/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package modeloqytetet;

import java.util.ArrayList;
import java.lang.Comparable;

/**
 *
 * @author sofiafernandezmoreno
 */
public abstract class Jugador implements Comparable<Jugador> {

    private boolean encarcelado;
    private String nombre;
    private int saldo;
    private ArrayList<TituloPropiedad> propiedades = new ArrayList<>();
    private Casilla casillaActual;
    private Sorpresa cartaLibertad;

    //Constructor nuevo(nombre)
    protected Jugador(String nombre) {

        this.encarcelado = false;
        this.nombre = nombre;
        this.saldo = 7500;
    }

    //Constructor copia(otroJugador)
    protected Jugador(Jugador otroJugador) {
        this.encarcelado = otroJugador.encarcelado;
        this.nombre = otroJugador.nombre;
        this.saldo = otroJugador.saldo;
        this.casillaActual = otroJugador.casillaActual;
        this.cartaLibertad = otroJugador.cartaLibertad;
        this.propiedades = otroJugador.propiedades;
    }

    boolean getEncarcelado() {
        return encarcelado;
    }

    void setEncarcelado(boolean encarcelado) {
        this.encarcelado = encarcelado;
    }

   
    String getNombre() {
        return nombre;
    }

    void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public int getSaldo() {
        return saldo;
    }

    void setSaldo(int saldo) {
        this.saldo = saldo;
    }

    ArrayList<TituloPropiedad> getPropiedades() {
        return propiedades;
    }

    public void setPropiedades(ArrayList<TituloPropiedad> propiedades) {
        this.propiedades = propiedades;
    }

    Casilla getCasillaActual() {
        return casillaActual;
    }

    void setCasillaActual(Casilla casillaActual) {
        this.casillaActual = casillaActual;
    }

    Sorpresa getCartaLibertad() {
        return cartaLibertad;
    }

    void setCartaLibertad(Sorpresa carta) {
        cartaLibertad = carta;
    }

    @Override
    public String toString() {
        return "Jugador{" + "encarcelado=" + encarcelado + ", nombre=" + nombre + ", saldo=" + saldo + ", capital= " + obtenerCapital() + ", propiedades=" + propiedades + ", cartaLibertad=" + cartaLibertad + ", casillaActual=" + casillaActual + '}';
    }

    @Override
    public int compareTo(Jugador otroJugador) {
        int otroCapital = otroJugador.obtenerCapital();

        if (otroCapital > obtenerCapital()) {
            return 1;
        } else if (otroCapital < obtenerCapital()) {
            return -1;
        }
        return 0;
    }

    int cuantasCasasHotelesTengo() {
        int casas = 0, hoteles = 0;
        for (TituloPropiedad propiedad : propiedades) {
            casas = casas + propiedad.getNumCasas();
            hoteles = hoteles + propiedad.getNumHoteles();
        }
        return casas + hoteles;
    }

    Sorpresa devolverCartaLibertad() {
        Sorpresa aux = this.cartaLibertad;
        if (this.cartaLibertad != null) {
            this.cartaLibertad = null;
        }
        return aux;
    }

    int obtenerCapital() {
        int capital = this.saldo;
        for (TituloPropiedad p : propiedades) {
            if (p.getHipotecada()) {
                capital = capital + ((p.getPrecioCompra() + p.getNumCasas() + p.getNumHoteles()) * p.getPrecioEdificar()) - p.getHipotecaBase();
            } else {
                capital = capital + ((p.getPrecioCompra() + p.getNumCasas() + p.getNumHoteles()) * p.getPrecioEdificar());

            }
        }
        return capital;

    }

    protected void pagarImpuesto() {
        modificarSaldo(casillaActual.getCoste());

    }

    boolean tengoCartaLibertad() {
        boolean encontrado = false;
        if (this.cartaLibertad != null) {
            encontrado = true;

        }
        return encontrado;
    }

    boolean esDeMiPropiedad(TituloPropiedad titulo) {
        boolean encontrado = false;
        //Terminar
        for (TituloPropiedad p : propiedades) {
            if (p == titulo) {
                encontrado = true;
            }
        }
        return encontrado;
    }

    int modificarSaldo(int cantidad) {
        int nuevoSaldo = this.saldo + cantidad;
        return nuevoSaldo;

    }

    ArrayList<TituloPropiedad> obtenerPropiedades(boolean estadoHipoteca) {
        ArrayList<TituloPropiedad> propiedadesHipotecadas = new ArrayList();
        if (estadoHipoteca == true) {
            for (TituloPropiedad p : propiedades) {
                if (p.getHipotecada() == true) {
                    propiedadesHipotecadas.add(p);
                }
            }
        } else {
            for (TituloPropiedad p : propiedades) {
                if (p.getHipotecada() == false) {
                    propiedadesHipotecadas.add(p);
                }
            }

        }
        return propiedadesHipotecadas;
    }

    protected boolean tengoSaldo(int cantidad) {
        boolean encontrado = false;
        if (this.saldo > cantidad) {
            encontrado = true;
        }
        return encontrado;
    }

boolean comprarTituloPropiedad(){
        boolean comprado = false;
        int costeCompra = casillaActual.getCoste();
        if(costeCompra < saldo){
            TituloPropiedad titulo = ((Calle)casillaActual).asignarPropietario(this);
            propiedades.add(titulo);
            modificarSaldo(-costeCompra);
            comprado = true;
        }
        return comprado;
    }

   

    boolean edificarCasa(TituloPropiedad titulo) {

        boolean edificada = false;

        if (puedoEdificarCasa(titulo)) {
            int costeEdificarCasa = titulo.getPrecioEdificar();

            boolean tengoSaldo = this.tengoSaldo(costeEdificarCasa);

            if (tengoSaldo) {

                titulo.edificarCasa();

                //3.5
                this.modificarSaldo(-costeEdificarCasa);
                edificada = true;
            }
        }
        return edificada;
    }

    boolean edificarHotel(TituloPropiedad titulo) {

        boolean edificada = false;
        //3.2
        if (puedoEdificarHotel(titulo)) {
            int costeEdificarHotel = titulo.getPrecioEdificar();
            //3.3
            boolean tengoSaldo = this.tengoSaldo(costeEdificarHotel);

            //3.4
            if (tengoSaldo) {

                titulo.edificarHotel();

                //3.5
                modificarSaldo(-costeEdificarHotel);
                edificada = true;
            }
        }
        return edificada;
    }

    void irACarcel(Casilla casilla) {
        setCasillaActual(casilla);
        setEncarcelado(true);
    }

    void pagarLibertad(int cantidad) {
        boolean tengoSaldo = tengoSaldo(cantidad);
        if (tengoSaldo) {
            setEncarcelado(false);
            modificarSaldo(-cantidad);
        }
    }

    void pagarAlquiler() {
        int costeAlquiler = ((Calle)casillaActual).pagarAlquiler();
        modificarSaldo(-costeAlquiler);
    }

    boolean deboPagarAlquiler() {

        //Arreglar preguntando a Nuria
        //1
        TituloPropiedad titulo = casillaActual.getTitulo();
        //2
        boolean esDeMiPropiedad = esDeMiPropiedad(titulo);

        boolean tienePropietario = false;

        boolean estaHipotecada = false;

        //3
        if (!esDeMiPropiedad) {
            tienePropietario = ((Calle)casillaActual).tengoPropietario();
            //4
            if (tienePropietario) {
                encarcelado = titulo.propietarioEncarcelado();
                //5
                if (!encarcelado) {
                    estaHipotecada = titulo.getHipotecada();
                }
            }
        }

        return !esDeMiPropiedad && tienePropietario && !encarcelado && !estaHipotecada;

    }

    void hipotecarPropiedad(TituloPropiedad titulo){
        int costeHipoteca = titulo.hipotecar();
        modificarSaldo(costeHipoteca);
    }

    void venderPropiedad(Casilla casilla) {
        //2.1
        TituloPropiedad titulo = casilla.getTitulo();
        //2.2
        eliminarDeMisPropiedades(titulo);
        //2.3
        int precioVenta = titulo.calcularPrecioVenta();
        //2.4
        modificarSaldo(precioVenta);

    }

    void eliminarDeMisPropiedades(TituloPropiedad titulo) {
        //2.2.1
        propiedades.remove(titulo);
        //2.2.2
        titulo.setPropietario(null);
    }

    boolean cancelarHipoteca(TituloPropiedad titulo) {
        boolean cancelaHipoteca = false;
        int costeCancelar = titulo.calcularCosteCancelar();
        boolean tengoSaldo = tengoSaldo(costeCancelar);
        if (tengoSaldo) {
            titulo.cancelarHipoteca();
            cancelaHipoteca = true;
        }
        return cancelaHipoteca;

    }

    protected Especulador convertirme(int fianza) {

        Especulador especulador = new Especulador(this, fianza);
        return especulador;

    }

    protected boolean deboIrACarcel() {

        return !tengoCartaLibertad();

    }

    protected boolean puedoEdificarCasa(TituloPropiedad titulo) {
        if (tengoSaldo(titulo.getPrecioEdificar()) && titulo.getNumCasas() < 4) {
            return true;
        }
        return false;
    }

    protected boolean puedoEdificarHotel(TituloPropiedad titulo) {
        if (tengoSaldo(titulo.getPrecioEdificar()) && titulo.getNumHoteles() < 4 && titulo.getNumCasas() == 4) {
            return true;
        }
        return false;
    }
}
