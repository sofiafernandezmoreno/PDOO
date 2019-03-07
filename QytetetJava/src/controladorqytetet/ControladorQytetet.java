/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controladorqytetet;

import java.util.ArrayList;
import modeloqytetet.EstadoJuego;
import modeloqytetet.MetodoSalirCarcel;
import modeloqytetet.Qytetet;

/**
 *
 * @author sofiafernandezmoreno
 */
public class ControladorQytetet {

    private static ControladorQytetet instance = new ControladorQytetet();

    private ArrayList<String> nombreJugadores = new ArrayList<>();
    private Qytetet modelo = Qytetet.getInstance();

    private ControladorQytetet() {
    }

    public static ControladorQytetet getInstance() {
        return instance;
    }

    public void setNombreJugadores(ArrayList<String> nombreJugadores) {
        this.nombreJugadores = nombreJugadores;
    }

    public ArrayList<Integer> obtenerOperacionesJuegoValidas() {
        ArrayList<Integer> operacionesPermitidas = new ArrayList<>();
        if (modelo.getJugadores().isEmpty()) {
            operacionesPermitidas.add(OpcionMenu.INICIARJUEGO.ordinal());
        } else {
            if (modelo.getEstadoJuego() == EstadoJuego.ALGUNJUGADORENBANCARROTA) {
                operacionesPermitidas.add(OpcionMenu.OBTENERRANKING.ordinal());
            } else if (modelo.getEstadoJuego() == EstadoJuego.JA_PREPARADO) {
                operacionesPermitidas.add(OpcionMenu.JUGAR.ordinal());
            } else if (modelo.getEstadoJuego() == EstadoJuego.JA_PUEDEGESTIONAR) {
                operacionesPermitidas.add(OpcionMenu.PASARTURNO.ordinal());
                operacionesPermitidas.add(OpcionMenu.VENDERPROPIEDAD.ordinal());
                operacionesPermitidas.add(OpcionMenu.HIPOTECARPROPIEDAD.ordinal());
                operacionesPermitidas.add(OpcionMenu.CANCELARHIPOTECA.ordinal());
                operacionesPermitidas.add(OpcionMenu.EDIFICARCASA.ordinal());
                operacionesPermitidas.add(OpcionMenu.EDIFICARHOTEL.ordinal());
                
            } else if (modelo.getEstadoJuego() == EstadoJuego.JA_PUEDECOMPRAROGESTIONAR) {
                operacionesPermitidas.add(OpcionMenu.COMPRARTITULOPROPIEDAD.ordinal());
                operacionesPermitidas.add(OpcionMenu.VENDERPROPIEDAD.ordinal());
                operacionesPermitidas.add(OpcionMenu.HIPOTECARPROPIEDAD.ordinal());
                operacionesPermitidas.add(OpcionMenu.CANCELARHIPOTECA.ordinal());
                operacionesPermitidas.add(OpcionMenu.EDIFICARCASA.ordinal());
                operacionesPermitidas.add(OpcionMenu.EDIFICARHOTEL.ordinal());
                operacionesPermitidas.add(OpcionMenu.PASARTURNO.ordinal());
            } else if (modelo.getEstadoJuego() == EstadoJuego.JA_CONSORPRESA) {
                operacionesPermitidas.add(OpcionMenu.APLICARSORPRESA.ordinal());
            } else if (modelo.getEstadoJuego() == EstadoJuego.JA_ENCARCELADO) {
                operacionesPermitidas.add(OpcionMenu.PASARTURNO.ordinal());
            } else if (modelo.getEstadoJuego() == EstadoJuego.JA_ENCARCELADOCONOPCIONDELIBERTAD) {
                operacionesPermitidas.add(OpcionMenu.INTENTARSALIRCARCELPAGANDOLIBERTAD.ordinal());
                operacionesPermitidas.add(OpcionMenu.INTENTARSALIRCARCELTIRANDODADO.ordinal());
            }

            operacionesPermitidas.add(OpcionMenu.MOSTRARJUGADORACTUAL.ordinal());
            operacionesPermitidas.add(OpcionMenu.MOSTRARJUGADORES.ordinal());
            operacionesPermitidas.add(OpcionMenu.MOSTRARTABLERO.ordinal());
            operacionesPermitidas.add(OpcionMenu.TERMINARJUEGO.ordinal());
        }

        return operacionesPermitidas;

    }

    public boolean necesitaElegirCasilla(int opcionMenu) {
        OpcionMenu opcion = OpcionMenu.values()[opcionMenu];
        return opcion == OpcionMenu.HIPOTECARPROPIEDAD || opcion == OpcionMenu.CANCELARHIPOTECA
                || opcion == OpcionMenu.EDIFICARCASA || opcion == OpcionMenu.EDIFICARHOTEL
                || opcion == OpcionMenu.VENDERPROPIEDAD;

    }

    public ArrayList<Integer> obtenerCasillasValidas(int opcionMenu) {
        OpcionMenu opcion = OpcionMenu.values()[opcionMenu];

        if (opcion == OpcionMenu.HIPOTECARPROPIEDAD) {
            return modelo.obtenerPropiedadesJugadorSegunEstadoHipoteca(false);
        } else if (opcion == OpcionMenu.CANCELARHIPOTECA) {
            return modelo.obtenerPropiedadesJugadorSegunEstadoHipoteca(true);
        } else if (opcion == OpcionMenu.EDIFICARCASA) {
            return modelo.obtenerPropiedadesJugador();
        } else if (opcion == OpcionMenu.EDIFICARHOTEL) {
            return modelo.obtenerPropiedadesJugador();
        } else if (opcion == OpcionMenu.VENDERPROPIEDAD) {
            return modelo.obtenerPropiedadesJugador();
        }

        return null;

    }

    public String realizarOperacion(int opcionElegida, int casillaElegida) throws Exception {
        OpcionMenu opcion = OpcionMenu.values()[opcionElegida];
        String mensaje = "";

        if (opcion == OpcionMenu.INICIARJUEGO) {
            modelo.inicializarJuego(nombreJugadores);
        } else if (opcion == OpcionMenu.JUGAR) {
            modelo.jugar();
            mensaje = "El dado ha sido tirado y ha salido un: " + modelo.getValorDado() + ".\n" + modelo.obtenerCasillaJugadorActual();
        } else if (opcion == OpcionMenu.APLICARSORPRESA) {
            mensaje = "Sorpresa aplicada:\n" + modelo.getCartaActual();
            modelo.aplicarSorpresa();
        } else if (opcion == OpcionMenu.INTENTARSALIRCARCELPAGANDOLIBERTAD) {
            modelo.intentarSalirCarcel(MetodoSalirCarcel.PAGANDOLIBERTAD);
            if (modelo.jugadorActualEncarcelado()) {
                mensaje = "No se pudo salir de la cárcel.";
            }
        } else if (opcion == OpcionMenu.INTENTARSALIRCARCELTIRANDODADO) {
            modelo.intentarSalirCarcel(MetodoSalirCarcel.TIRANDODADO);
            if (modelo.jugadorActualEncarcelado()) {
                mensaje = "No se pudo salir de la cárcel.";
            }
        } else if (opcion == OpcionMenu.COMPRARTITULOPROPIEDAD) {
            boolean comprado = modelo.comprarTituloPropiedad();

            mensaje = "Comprada propiedad";
            if (!comprado) {
                mensaje = "No se pudo comprar. ";
            }
        } else if (opcion == OpcionMenu.CANCELARHIPOTECA) {
            boolean cancelada = modelo.cancelarHipoteca(casillaElegida);
            if (!cancelada) {
                mensaje = "No se pudo cancelar. ";
            }
            else{
                mensaje = "Cancelada hipoteca";
            }
        } else if (opcion == OpcionMenu.EDIFICARCASA) {
            boolean sepudo = modelo.edificarCasa(casillaElegida);
            if (!sepudo) {
                mensaje = "No se pudo edificar la casa. ";
            }
            else{
                mensaje = "Edificada la casa. ";
            }
        } else if (opcion == OpcionMenu.EDIFICARHOTEL) {
            boolean sepudo = modelo.edificarHotel(casillaElegida);
            if (!sepudo) {
                mensaje = "No se pudo edificar el hotel. ";
            }
            else{
                mensaje = "Edificado el hotel. ";
            }
        } else if (opcion == OpcionMenu.VENDERPROPIEDAD) {
            modelo.venderPropiedad(casillaElegida);
            mensaje = "Vendida propiedad. ";

        } else if (opcion == OpcionMenu.PASARTURNO) {
            modelo.siguienteJugador();
        } else if (opcion == OpcionMenu.OBTENERRANKING) {
            modelo.obtenerRanking();
        } else if (opcion == OpcionMenu.TERMINARJUEGO) {
            System.out.println("FIN QYTETET");
            System.exit(0);
        } else if (opcion == OpcionMenu.MOSTRARJUGADORACTUAL) {
            mensaje = modelo.getJugadorActual().toString();
        } else if (opcion == OpcionMenu.MOSTRARJUGADORES) {
            mensaje = modelo.getJugadores().toString();
        } else if (opcion == OpcionMenu.MOSTRARTABLERO) {
            mensaje = modelo.getTablero().toString();
        } else if (opcion == OpcionMenu.HIPOTECARPROPIEDAD) {
            modelo.hipotecarPropiedad(casillaElegida);
            mensaje = "Hipotecada propiedad. ";
        }
        

        return mensaje;

    }

}
