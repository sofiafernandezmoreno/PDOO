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
public class Especulador extends Jugador {

    private int fianza;
    
    //Constructor copia(unJugador, fianza)
    protected Especulador(Jugador jugador, int fianza) {
        super(jugador);
        this.fianza = fianza;
    }

    @Override
    protected Especulador convertirme(int fianza) {
        return this;
    }

    private boolean pagarFianza() {
        boolean pagada = super.tengoSaldo(fianza);
        if (pagada) {
            super.modificarSaldo(-fianza);
        }

        return pagada;
    }

    @Override
    protected boolean deboIrACarcel() {
        return super.deboIrACarcel() && !pagarFianza();
    }

    @Override
    protected void pagarImpuesto() {
        if (getCasillaActual() != null) {
            super.modificarSaldo(-getCasillaActual().getCoste() / 2);
        }
    }

    

    @Override
    protected boolean puedoEdificarCasa(TituloPropiedad titulo){
        if(super.tengoSaldo(titulo.getPrecioEdificar()) && titulo.getNumCasas() < 8)
            return true;
        return false;
    }
    
    @Override
    protected boolean puedoEdificarHotel(TituloPropiedad titulo){
        if(super.tengoSaldo(titulo.getPrecioEdificar()) && titulo.getNumHoteles()< 8 && titulo.getNumCasas() >= 4)
            return true;
        return false;
    }

      @Override
    public String toString(){
        return super.toString() +"\nSoy especulador.  "+ "Mi fianza es: " + this.fianza;
    }

}
