/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package modeloqytetet;

import java.util.*;
import static java.util.Collections.shuffle;

/**
 *
 * @author sofiafernandezmoreno
 */
public class Qytetet {

    private ArrayList<Sorpresa> mazo = new ArrayList<>();
    private Tablero tablero = new Tablero();
    private EstadoJuego estado;

    private Dado dado = Dado.getInstance();
    private Sorpresa cartaActual;
    private ArrayList<Jugador> jugadores = new ArrayList();
    private Jugador jugadorActual;

    public final static int MAX_JUGADORES = 4;
    static final int MAX_SORPRESAS = 10;
    public static final int MAX_CASILLAS = 20;
    static final int PRECIO_LIBERTAD = 200;
    static final int SALDO_SALIDA = 1000;

    private static final Qytetet instance = new Qytetet();

    private Qytetet() {
        setCartaActual(null);
    } // Constructor

    public static Qytetet getInstance() {
        return instance;
    }

    ArrayList<Sorpresa> getMazo() {
        return mazo;
    }

    public Tablero getTablero() {
        return tablero;
    }

    Dado getDado() {
        return dado;
    }

    public Sorpresa getCartaActual() {
        return cartaActual;
    }

    private void setCartaActual(Sorpresa cartaActual) {
        this.cartaActual = cartaActual;
    }

    public ArrayList<Jugador> getJugadores() {
        return jugadores;
    }

    public void setJugadores(ArrayList<Jugador> jugadores) {
        this.jugadores = jugadores;
    }

    public Jugador getJugadorActual() {
        return jugadorActual;
    }

    public void setJugadorActual(Jugador jugadorActual) {
        this.jugadorActual = jugadorActual;
    }

    private void inicializarCartasSorpresa() {

        int randomNum1 = 3000 + (int) (Math.random() * 5000);
        int randomNum2 = 3000 + (int) (Math.random() * 5000);
        mazo.add(new Sorpresa("UHHH me convierto en Especulador", TipoSorpresa.CONVERTIRME, randomNum1));
        mazo.add(new Sorpresa("UHHH me convierto en Especulador", TipoSorpresa.CONVERTIRME, randomNum2));

        mazo.add(new Sorpresa("Un fan anónimo ha pagado tu fianza. Sales de la cárcel", TipoSorpresa.SALIRCARCEL, 0));
        mazo.add(new Sorpresa("Los killos te mandan de paseico", TipoSorpresa.IRACASILLA, 1));
        mazo.add(new Sorpresa("Lo siento, pero te quitamos un pizquito de tu saldo", TipoSorpresa.PAGARCOBRAR, 2));
        mazo.add(new Sorpresa("Nos debes dinerico señor, ¡a pagar!", TipoSorpresa.PORCASAHOTEL, 3));
        mazo.add(new Sorpresa("Killo que te toca pagar, $$$ , MALO MARIA", TipoSorpresa.PORJUGADOR, 4));
        mazo.add(new Sorpresa("Killo que ahora si te llevas el pellizquito", TipoSorpresa.PORJUGADOR, 5));
        mazo.add(new Sorpresa("Los killos te mandan de paseico un ratejo por si no te ha tocado", TipoSorpresa.IRACASILLA, 6));
        mazo.add(new Sorpresa("Fiuuuuuuu, que alegría que recibes dinerico", TipoSorpresa.PAGARCOBRAR, 7));
        mazo.add(new Sorpresa("Alegria señora que nos llevamos dinerico", TipoSorpresa.PORCASAHOTEL, 8));
        mazo.add(new Sorpresa("Te hemos pillado con chanclas y calcetines, lo sentimos,¡debes ir a la carcel!", TipoSorpresa.IRACASILLA, 9));

        shuffle(mazo);
    }

    private void inicializarTablero() {
        tablero = new Tablero();
    }

    private void inicializarJugadores(ArrayList<String> nombres) {
        jugadores = new ArrayList();
        for (String nombre : nombres) {
            jugadores.add(new Jugador(nombre) {
            });
        }
    }

    public void inicializarJuego(ArrayList<String> nuevosjugadores) throws Exception {
        inicializarJugadores(nuevosjugadores);
        inicializarCartasSorpresa();
        inicializarTablero();
        salidaJugadores();

    }

    public void siguienteJugador() {
        //Preguntar duda ¿utilizar metodo intentar salir carcel?

        int pos = jugadores.indexOf(jugadorActual);
        jugadorActual = jugadores.get((pos + 1) % jugadores.size());
        if (jugadorActual.getEncarcelado() == true) {
            estado = EstadoJuego.JA_ENCARCELADOCONOPCIONDELIBERTAD;
        } else {
            estado = EstadoJuego.JA_PREPARADO;
        }
    }

    void salidaJugadores() {
        for (Jugador j : jugadores) {

            //if (j.getCasillaActual().getTipo() != TipoCasilla.SALIDA) {
            j.setCasillaActual(this.tablero.obtenerCasillaNumero(0));//en el tablero la casilla 0 es la salida
            //}
        }
        jugadorActual = jugadores.get((int) (Math.random() * jugadores.size()));
        estado = EstadoJuego.JA_PREPARADO;
    }

    public ArrayList<Integer> obtenerPropiedadesJugador() {

        ArrayList<Integer> propiedadesJugadorNuevas = new ArrayList();

        for (TituloPropiedad p : jugadorActual.getPropiedades()) {
            for (Casilla s : tablero.getCasillas()) {
                if (s.getTitulo() == p) {
                    propiedadesJugadorNuevas.add(s.getNumeroCasilla());
                }
            }

        }
        return propiedadesJugadorNuevas;

    }

    public ArrayList<Integer> obtenerPropiedadesJugadorSegunEstadoHipoteca(boolean estadoHipoteca) {

        ArrayList<Integer> propiedadesJugadorNuevas = new ArrayList();
        for (TituloPropiedad p : jugadorActual.getPropiedades()) {
            for (Casilla s : tablero.getCasillas()) {
                if (s.getTitulo() == p && p.getHipotecada() == estadoHipoteca) {
                    propiedadesJugadorNuevas.add(s.getNumeroCasilla());
                }
            }
        }
        return propiedadesJugadorNuevas;
    }

    boolean jugadorActualEnCalleLibre() {
        boolean encontrado = false;
        for (TituloPropiedad p : jugadorActual.getPropiedades()) {
            if (jugadorActual.getCasillaActual().soyEdificable() && p.getPropietario() == null) {
                encontrado = true;
            }
        }
        return encontrado;
    }

    public boolean jugadorActualEncarcelado() {
        return jugadorActual.getEncarcelado();
    }

    public void jugar() {

        int valorDado = this.dado.Tirar();
        Casilla casillaPosicion = this.jugadorActual.getCasillaActual();
        Casilla casillaFinal = this.tablero.obtenerCasillaFinal(casillaPosicion, valorDado);
        mover(casillaFinal.getNumeroCasilla());

    }

    public void obtenerRanking() {
        Collections.sort(jugadores);
    }

    int obtenerSaldoJugadorActual() {
        return this.jugadorActual.getSaldo();
    }

    int tirarDado() {
        return this.dado.Tirar();
    }

    public int getValorDado() {
        return this.dado.getValor();
    }

    @Override
    public String toString() {
        return "Qytetet{" + "mazo=" + mazo + ", tablero=" + tablero + ", dado=" + dado + ", cartaActual=" + cartaActual + ", jugadores=" + jugadores + ", jugadorActual=" + jugadorActual + '}';
    }

    void actuarSiEnCasillaEdificable() {
        Casilla casilla;
        boolean deboPagar = jugadorActual.deboPagarAlquiler();
        if (deboPagar) {
            jugadorActual.pagarAlquiler();
            if (jugadorActual.getSaldo() <= 0) {
                setEstadoJuego(EstadoJuego.ALGUNJUGADORENBANCARROTA);

            }
        }
        casilla = obtenerCasillaJugadorActual();
        if (estado == EstadoJuego.ALGUNJUGADORENBANCARROTA) {
            boolean tengoPropietario = ((Calle) casilla).tengoPropietario();
            if (tengoPropietario) {
                setEstadoJuego(EstadoJuego.JA_PUEDEGESTIONAR);
            } else {
                setEstadoJuego(EstadoJuego.JA_PUEDECOMPRAROGESTIONAR);
            }
        }
    }

    public EstadoJuego getEstadoJuego() {
        return estado;
    }

    public Casilla obtenerCasillaJugadorActual() {
        return jugadorActual.getCasillaActual();
    }

    public void setEstadoJuego(EstadoJuego estado) {
        this.estado = estado;
    }

    void actuarSiEnCasillaNoEdificable() {
        setEstadoJuego(EstadoJuego.JA_PUEDEGESTIONAR);
        Casilla casillaActual = jugadorActual.getCasillaActual();
        if (casillaActual.getTipo() == TipoCasilla.IMPUESTO) {
            jugadorActual.pagarImpuesto();
        } else {
            if (casillaActual.getTipo() == TipoCasilla.JUEZ) {
                encarcelarJugador();
            } else if (casillaActual.getTipo() == TipoCasilla.SORPRESA) {
                cartaActual = mazo.remove(0);
                setEstadoJuego(EstadoJuego.JA_CONSORPRESA);
            }
        }
    }

    public void aplicarSorpresa() {
        setEstadoJuego(EstadoJuego.JA_PUEDEGESTIONAR);

        if (cartaActual.getTipo() == TipoSorpresa.SALIRCARCEL) {
            jugadorActual.setCartaLibertad(cartaActual);
        } else {
            mazo.add(cartaActual);
        }

        if (cartaActual.getTipo() == TipoSorpresa.PAGARCOBRAR) {
            jugadorActual.modificarSaldo(cartaActual.getValor());
            if (jugadorActual.getSaldo() < 0) {
                setEstadoJuego(EstadoJuego.ALGUNJUGADORENBANCARROTA);
            }
        } else if (cartaActual.getTipo() == TipoSorpresa.IRACASILLA) {
            int valor = cartaActual.getValor();
            boolean casillaCarcel = tablero.esCasillaCarcel(valor);
            if (casillaCarcel) {
                encarcelarJugador();
            } else {
                mover(valor);
            }

        } else if (cartaActual.getTipo() == TipoSorpresa.PORCASAHOTEL) {
            int cantidad = cartaActual.getValor();
            int numeroTotal = jugadorActual.cuantasCasasHotelesTengo();
            jugadorActual.modificarSaldo(numeroTotal * cantidad);
            if (jugadorActual.getSaldo() < 0) {
                setEstadoJuego(EstadoJuego.ALGUNJUGADORENBANCARROTA);
            }
        } else if (cartaActual.getTipo() == TipoSorpresa.PORJUGADOR) {
            for (Jugador j : jugadores) {
                if (j != jugadorActual) {
                    j.modificarSaldo(cartaActual.getValor());
                }
                if (j.getSaldo() < 0) {
                    setEstadoJuego(EstadoJuego.ALGUNJUGADORENBANCARROTA);
                } else {
                    jugadorActual.modificarSaldo(-cartaActual.getValor());
                }
                if (jugadorActual.getSaldo() < 0) {
                    setEstadoJuego(EstadoJuego.ALGUNJUGADORENBANCARROTA);
                }
            }
        } else if (cartaActual.getTipo() == TipoSorpresa.CONVERTIRME) {
            Especulador especulador = jugadorActual.convertirme(cartaActual.getValor());//Preguntar

            int pos = jugadores.indexOf(jugadorActual);
            jugadores.remove(pos);
            jugadores.add(especulador);
            jugadorActual = especulador;
            System.out.println("-----------------AHORA ERES UN ESPECULADOR-------------");

        }

    }

    public boolean comprarTituloPropiedad() {
        boolean comprado = jugadorActual.comprarTituloPropiedad();
        if (comprado) {
            setEstadoJuego(EstadoJuego.JA_PUEDEGESTIONAR);
        }
        return comprado;

    }

    public boolean edificarCasa(int numeroCasilla) {
        boolean edificada = false;
        //1
        Casilla casilla = tablero.obtenerCasillaNumero(numeroCasilla);
        //2
        TituloPropiedad titulo = casilla.getTitulo();
        //3
        edificada = jugadorActual.edificarCasa(titulo);
        if (edificada == true) {//hayEspacio && tengoSaldo
            //4
            setEstadoJuego(EstadoJuego.JA_PUEDEGESTIONAR);
        }
        return edificada;
    }

    public boolean edificarHotel(int numeroCasilla) {
        boolean edificada = false;
        //1
        Casilla casilla = tablero.obtenerCasillaNumero(numeroCasilla);
        //2
        TituloPropiedad titulo = casilla.getTitulo();
        //3
        edificada = jugadorActual.edificarHotel(titulo);
        if (edificada == true) {//hayEspacio && tengoSaldo
            //4
            setEstadoJuego(EstadoJuego.JA_PUEDEGESTIONAR);
        }
        return edificada;
    }

    private void encarcelarJugador() {
        Casilla casillaCarcel = tablero.getCarcel();
        if (!jugadorActual.deboIrACarcel()) {

            jugadorActual.irACarcel(casillaCarcel);
            setEstadoJuego(EstadoJuego.JA_ENCARCELADO);
        } else {
            Sorpresa carta = jugadorActual.devolverCartaLibertad();
            mazo.add(carta);
            setEstadoJuego(EstadoJuego.JA_PUEDEGESTIONAR);
        }
    }

    public boolean intentarSalirCarcel(MetodoSalirCarcel metodo) {
        if (metodo == MetodoSalirCarcel.TIRANDODADO) {
            int resultado = tirarDado();
            if (resultado >= 5) {
                jugadorActual.setEncarcelado(false);
            }
        } else if (metodo == MetodoSalirCarcel.PAGANDOLIBERTAD) {
            jugadorActual.pagarLibertad(PRECIO_LIBERTAD);
        }
        boolean libre = jugadorActual.getEncarcelado();
        if (libre) {
            setEstadoJuego(EstadoJuego.JA_ENCARCELADO);
        } else {
            setEstadoJuego(EstadoJuego.JA_PREPARADO);
        }
        return libre;
    }

    void mover(int numCasillaDestino) {
        Casilla casillaInicial = jugadorActual.getCasillaActual();
        Casilla casillaFinal = tablero.obtenerCasillaNumero(numCasillaDestino);
        jugadorActual.setCasillaActual(casillaFinal);
        if (numCasillaDestino < casillaInicial.getNumeroCasilla()) {
            jugadorActual.modificarSaldo(SALDO_SALIDA);
        }
        if (casillaFinal.soyEdificable()) {
            actuarSiEnCasillaEdificable();
        } else {
            actuarSiEnCasillaNoEdificable();
        }
    }

    public void hipotecarPropiedad(int numeroCasilla) {
        Casilla casilla = tablero.obtenerCasillaNumero(numeroCasilla);
        TituloPropiedad titulo = casilla.getTitulo();
        jugadorActual.hipotecarPropiedad(titulo);
        setEstadoJuego(EstadoJuego.JA_PUEDEGESTIONAR);
    }

    public void venderPropiedad(int numeroCasilla) {

        //1
        Casilla casilla = tablero.obtenerCasillaNumero(numeroCasilla);
        //2
        jugadorActual.venderPropiedad(casilla);
        setEstadoJuego(EstadoJuego.JA_PUEDEGESTIONAR);

    }

    public boolean cancelarHipoteca(int numCasilla) {

        boolean cancelarHipoteca = false;
        Casilla casilla = tablero.obtenerCasillaNumero(numCasilla);
        TituloPropiedad titulo = casilla.getTitulo();
        boolean estaHipotecada = casilla.getTitulo().getHipotecada();
        boolean esDeMiPropiedad = jugadorActual.esDeMiPropiedad(titulo);
        boolean esEdificable = casilla.soyEdificable();
        if (esEdificable && esDeMiPropiedad && estaHipotecada) {
            cancelarHipoteca = jugadorActual.cancelarHipoteca(titulo);
        }

        estado = EstadoJuego.JA_PUEDEGESTIONAR;
        return cancelarHipoteca;

    }

}
