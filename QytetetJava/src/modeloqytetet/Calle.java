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
public class Calle extends Casilla{
    //Constructor para TipoCasillas que son calle
    private TituloPropiedad titulo;
    
    Calle (int numCasilla, TituloPropiedad tp){
        super(numCasilla, tp.getPrecioCompra());
        titulo = tp;
    }
    
    public TituloPropiedad asignarPropietario(Jugador jugador){
        titulo.setPropietario(jugador);
        return titulo;
    }
    
    @Override
    protected TipoCasilla getTipo(){
        return TipoCasilla.CALLE;
    }

    @Override
    protected TituloPropiedad getTitulo(){
        return titulo;
    }

   
    public boolean tengoPropietario(){
        return titulo.tengoPropietario();
    }
    
    public int pagarAlquiler(){
        int costeAlquiler = titulo.pagarAlquiler();
        return costeAlquiler;
    }
    
    private void setTitulo(TituloPropiedad titulo) {
        this.titulo = titulo;
    }

    @Override
    protected boolean soyEdificable(){
        return true;
    }
    
    @Override
    public String toString(){
        return super.toString() + "\n - Tipo: CALLE\n - Titulo:\n" + titulo;
    }

    
}
