package fr.opendo.tools {
import fr.opendo.socket.User;

/**
 * @author Matt - Modified 2023-03-24
 */
public class UserItem extends AnimationItemView {
    private var _user:User;
    private const WIDTH:int = 336;
    private const HEIGHT:int = 336;

    public function UserItem(user:User) {
        _user = user;
        init();
    }

    private function init():void {
        $prenom.text = _user.prenom;
        Tools.displayUserPhoto(this, _user.photo_bitmap, WIDTH, HEIGHT, 80);
    }

    public function displayFirstName(state:Boolean):void {
        $prenom.visible = state;
    }
}
}