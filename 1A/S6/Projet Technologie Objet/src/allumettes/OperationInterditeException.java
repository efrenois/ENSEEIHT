package allumettes;

/**
 * Nouvelle exception levée par la procuration.
 *
 * @author Frenois Etan
 */
public class OperationInterditeException extends RuntimeException {

    public OperationInterditeException(String message) {
        super(message);
    }

}
