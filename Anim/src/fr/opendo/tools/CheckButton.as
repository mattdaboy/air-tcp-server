package fr.opendo.tools {
/**
 * @author noel
 */
public class CheckButton extends ContenueEditCheckSelectView {
    public function CheckButton() {
        $on.visible = false;
    }

    public function setOn():void {
        $on.visible = true;
    }

    public function setOff():void {
        $on.visible = false;
    }
}
}