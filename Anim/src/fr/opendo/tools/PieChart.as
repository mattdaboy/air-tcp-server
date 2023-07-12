package fr.opendo.tools {
import com.greensock.TweenLite;
import com.greensock.easing.Back;
import com.greensock.easing.Cubic;

import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;

/**
 * PieChart
 * @data string de la forme
 * var data:String = "0,6,2,7,3,0,1"
 * ou chaque chiffre est le nombre de choix pour cette réponse
 */
public class PieChart extends Sprite {
    private var _chart:Sprite;
    private var _radius:Number;
    private var _slicesNumber:uint;

    public function PieChart(nb_reponses:int, data:Array, radius:Number = 250) {
        _chart = new Sprite();
        addChild(_chart);
        _radius = radius;
        var startAngle:Number = 0;
        var totalValue:Number = 0;
        var colors:Array = [0xFF0000, 0x00FF00, 0x0000FF, 0xFFFF00, 0xFF00FF, 0x00FFFF]; // Couleurs des tranches

        // Calcule la somme totale des valeurs pour obtenir le pourcentage
        for each (var value:Number in data) {
            totalValue += value;
        }

        for (var i:int = 0; i < data.length; i++) {
            var sliceAngle:Number = data[i] / totalValue * (Math.PI * 2); // Calcule l'angle de la tranche en radians
            var endAngle:Number = startAngle + sliceAngle;

            // Dessine la tranche
            var slice:Shape = new Shape();
            drawSlice(slice.graphics, x, y, radius, startAngle, endAngle, colors[i % colors.length]);
            _chart.addChild(slice);

            // Fait une animation pour agrandir les tranches progressivement
            TweenLite.from(slice, Const.ANIM_DURATION, {scaleX: 0, scaleY: 0, ease: Back.easeOut});

            startAngle = endAngle; // Met à jour l'angle de départ pour la prochaine tranche
        }
    }

    function drawSlice(graphics:Graphics, centerX:Number, centerY:Number, radius:Number, startAngle:Number, endAngle:Number, color:uint):void {
        graphics.beginFill(color);
        graphics.moveTo(centerX, centerY);

        var angleDiff:Number = endAngle - startAngle;
        var segments:int = Math.ceil(Math.abs(angleDiff) / (Math.PI / 180)); // Divise l'angle en segments pour obtenir une approximation
        for (var i:int = 0; i <= segments; i++) {
            var angle:Number = startAngle + (i / segments) * angleDiff;
            var controlX:Number = centerX + Math.cos(angle) * radius;
            var controlY:Number = centerY + Math.sin(angle) * radius;
            graphics.lineTo(controlX, controlY);
        }

        graphics.lineTo(centerX, centerY);
        graphics.endFill();
    }

    private function degreesToRadians(degrees:Number):Number {
        return degrees * Math.PI / 180;
    }

    private function getRandomColor():uint {
        return Math.random() * 0xFFFFFF;
    }


    public function updatePieChart(newData:Array):void {
        // Calculer le total des nouvelles données pour obtenir le pourcentage
        var totalData:Number = 0;
        for (var i:int = 0; i < newData.length; i++) {
            totalData += newData[i];
        }

        // Angle de départ pour dessiner les tranches
        var startAngle:Number = -Math.PI / 2;

        // Durée de l'animation (en secondes)
        var animationDuration:Number = 1;

        // Mettre à jour les tranches avec des animations fluides
        for (i = 0; i < newData.length; i++) {
            // Calculer le nouvel angle de la tranche en fonction du pourcentage
            var percentage:Number = newData[i] / totalData;
            var newAngle:Number = percentage * Math.PI * 2;

            // Trouver la tranche correspondante dans le camembert
            var slice:Shape = _chart.getChildAt(i) as Shape;

            // Animation pour redimensionner la tranche
            TweenLite.to(slice, animationDuration, {scaleX: Math.cos(newAngle) * _radius, scaleY: Math.sin(newAngle) * _radius, ease: Cubic.easeOut});
        }

    }

}
}
