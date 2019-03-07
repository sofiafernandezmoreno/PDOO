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
public class OtraCasilla extends Casilla{
    private TipoCasilla tipo;
    
    OtraCasilla(int numeroCasilla, int coste, TipoCasilla tipo) {    
        super(numeroCasilla,coste);
        this.tipo = tipo;
    }

    @Override
    protected TipoCasilla getTipo() {
        return this.tipo;
    }

    @Override
    protected TituloPropiedad getTitulo() {
        return null;
    }

    @Override
    protected boolean soyEdificable() {
        return false;
    }
    
    @Override
    public String toString(){
        String to_S = super.toString() + "\nTipo de casilla: " + tipo;
        
        if(tipo == TipoCasilla.SALIDA){
            to_S += "\nCobra: " + super.getCoste();
        }
        else if(tipo == TipoCasilla.IMPUESTO){
            to_S += "\nPaga: " + super.getCoste();
        }
        to_S += "\n";
        
        return to_S;
    }
}

