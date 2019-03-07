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
public class Dado {
    
    private static final Dado instance = new Dado();
    private int valor;
    
    int Tirar(){
        
        valor = (int )((Math.random()*6)+1);
        return valor;
        
    }

    public int getValor() {
        return valor;
    }
    
    public static Dado getInstance(){
        
        return instance;
        
    }
    
    
}
