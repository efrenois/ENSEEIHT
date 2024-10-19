package allumettes;

import org.junit.*;
import static org.junit.Assert.*;

public class StrategieRapideTest {

    // précision pour les comparaisons réelle
    public final static double EPSILON = 0.001;

    private Jeu jeu1;
    private Jeu jeu2;
    private Jeu jeu3;
    private Jeu jeu4;
    private Jeu jeu13;
    private StrategieRapide stratRapide;

    @Before
    public void setUp() {

        jeu1 = new VraiJeu(1);
        jeu2 = new VraiJeu(2);
        jeu3 = new VraiJeu(3);
        jeu4 = new VraiJeu(4);
        jeu13 = new VraiJeu(13);

        stratRapide = new StrategieRapide();

    }

    @Test
    public void testerJeu1C14(){
        assertEquals(1, stratRapide.getPrise(jeu1), EPSILON);
    }

    @Test
    public void testerJeu2C14(){
        assertEquals(2, stratRapide.getPrise(jeu2), EPSILON);
    }

    @Test
    public void testerJeu3C14(){
        assertEquals(3, stratRapide.getPrise(jeu3), EPSILON);
    }

    @Test
    public void testerJeu4C14(){
        assertEquals(3, stratRapide.getPrise(jeu4), EPSILON);
    }
    @Test
    public void testerJeu13C14(){
        assertEquals(3, stratRapide.getPrise(jeu13), EPSILON);
    }

}
