package fr.opendo.tools {
import com.greensock.TweenLite;

import flash.display.Sprite;
import flash.events.MouseEvent;

import fr.opendo.events.CustomEvent;

public class DatePicker extends DatePickerView {
    private var _cellArray:Vector.<DateCell>;
    private var _selectedDateArray:Array;
    private var _currentAnnee:Number;
    private var _currentMois:Number;
    private var _currentJourDuMois:Number;
    private var _currentFirstDate:Date;
    private var _daysInMonth:Array;
    private var _cellsContainer:Sprite;
    private const CELL_GAP:Number = 50;
    private var _publicationsDates:Vector.<Date>;

    function DatePicker() {
        _cellsContainer = new Sprite();
        _cellsContainer.x = 45;
        _cellsContainer.y = 240;
        addChild(_cellsContainer);

        _cellArray = new Vector.<DateCell>();
        _selectedDateArray = [];

        $btnPrevMonth.buttonMode = true;
        $btnPrevMonth.mouseChildren = false;
        $btnPrevMonth.addEventListener(MouseEvent.CLICK, btnPrevMonthOnClick);

        $btnNextMonth.buttonMode = true;
        $btnNextMonth.mouseChildren = false;
        $btnNextMonth.addEventListener(MouseEvent.CLICK, btnNextMonthOnClick);

        $btnReset.buttonMode = true;
        $btnReset.mouseChildren = false;
        $btnReset.addEventListener(MouseEvent.CLICK, btnResetOnClick);
    }

    private function btnPrevMonthOnClick(event:MouseEvent):void {
        changeMonth(-1);
    }

    private function btnNextMonthOnClick(event:MouseEvent):void {
        changeMonth(+1);
    }

    private function btnResetOnClick(event:MouseEvent):void {
        init();
    }

    public function setContent(sessions_publications:Vector.<Date>):void {
        _publicationsDates = sessions_publications;
        init();
    }

    private function init():void {
        dispatchEvent(new CustomEvent(CustomEvent.APPLY_FILTERS, []));
        _selectedDateArray = [];
        var current_date:Date = new Date();
        $titre.text = formatDDay(current_date);
        constructCalendar(current_date.fullYear, current_date.month, 1);
    }

    private function constructCalendar(year:Number, month:Number, day:Number):void {
        clearCalendar();
        _cellsContainer.alpha = 0;
        _currentFirstDate = new Date(year, month, day);
        var init_month:String = DateUtils.isoToStringFrenchDate(DateUtils.dateToIso(_currentFirstDate));
        $month.text = init_month.split(" ")[1].toUpperCase() + " " + init_month.split(" ")[2];

        _currentAnnee = year;
        _currentMois = month;
        _currentJourDuMois = day;
        _daysInMonth = [31, isLeapYear(_currentAnnee) ? 29 : 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

        var isDisplayedMonth:Boolean;
        var end_date_num:uint = _daysInMonth[_currentMois];
        var jour_du_mois:Number = 0;
        var tab_index:Array = [6, 0, 1, 2, 3, 4, 5];
        var start_index_date:Number = tab_index[_currentFirstDate.getDay()];
        var xpos:Number = 0;
        var ypos:Number = 0;
        var current_date:Date;

        for (var i:uint = 0; i < 42; i++) {
            if (i < start_index_date) {
                isDisplayedMonth = false;
                current_date = getPreviousMonthDate(start_index_date - i);
            } else if (i >= start_index_date && i < end_date_num + start_index_date) {
                current_date = getSelectedMonthDate(i - start_index_date);
                isDisplayedMonth = true;
            } else if (i >= end_date_num) {
                isDisplayedMonth = false;
                current_date = getNextMonthDate(i - start_index_date - end_date_num);
            }
            jour_du_mois = current_date.date;
            var today:Date = new Date();
            var isToday:Boolean = false;

            if (today.day == current_date.day && today.date == current_date.date && today.month == current_date.month && today.fullYear == current_date.fullYear) {
                isToday = true;
            }

            var cell:DateCell = new DateCell(current_date, isToday);
            cell.x = xpos;
            cell.y = ypos;
            _cellArray.push(cell);
            _cellsContainer.addChild(cell);
            if (isAlreadySelectedDate(cell.date)) {
                cell.addEventListener(MouseEvent.CLICK, onCellClick);
                cell.select(true);
            }

            if (xpos == CELL_GAP * 6) {
                xpos = 0;
                ypos += CELL_GAP;
            } else {
                xpos += CELL_GAP;
            }
        }
        TweenLite.to(_cellsContainer, Const.ANIM_DURATION, {alpha: 1});

        // check data
        for each(var date_cell:DateCell in _cellArray) {
            var cell_date:String = DateUtils.dateToIso(date_cell.date, true);
            for each(var date:Date in _publicationsDates) {
                var p_date:String = DateUtils.dateToIso(date, true);
                if (cell_date == p_date) {
                    date_cell.addEventListener(MouseEvent.CLICK, onCellClick);
                    date_cell.setDataIn();
                    break;
                }
            }
        }
    }

    private function onCellClick(event:MouseEvent):void {
        var cell:DateCell = DateCell(event.currentTarget);
        cell.select(!cell.selected);
        if (cell.selected) {
            _selectedDateArray.push(cell.date);
        } else {
            removeDateFromArray(cell.date);
        }

        updateSelectedDate();
    }

    private function removeDateFromArray(date:Date):void {
        for (var i:int = _selectedDateArray.length - 1; i >= 0; i--) {
            var selected_date:Date = _selectedDateArray[i];
            if (selected_date.toString() == date.toString()) {
                _selectedDateArray.splice(i, 1);
                break;
            }
        }
        // _selectedDateArray.splice(_selectedDateArray.indexOf(cell.date), 1);
    }

    private function updateSelectedDate():void {
        dispatchEvent(new CustomEvent(CustomEvent.APPLY_FILTERS, _selectedDateArray));
    }

    private function isAlreadySelectedDate(cell_date:Date):Boolean {
        var exist:Boolean = false;
        for each(var date_selected:Date in _selectedDateArray) {
            if (date_selected.toString() == cell_date.toString()) {
                exist = true;
                break;
            }
        }
        return exist;
    }

    private function clearCalendar():void {
        _cellArray = new Vector.<DateCell>();
        while (_cellsContainer.numChildren > 0) {
            _cellsContainer.removeChildAt(0);
        }
    }

    private function changeMonth(factor:int):void {
        var new_month:Number = _currentMois + factor;
        switch (new_month) {
            case -1:
                _currentMois = 11;
                changeYear(-1);
                break;
            case 12:
                _currentMois = 0;
                changeYear(1);
                break
            default:
                constructCalendar(_currentAnnee, new_month, 1);
                break;
        }
    }

    private function changeYear(factor:int):void {
        var new_year:Number = _currentAnnee + factor;
        if (factor == -1) {
            constructCalendar(new_year, 11, 1);
        } else {
            constructCalendar(new_year, 0, 1);
        }
    }

    private function getPreviousMonthDate(num_days_before:Number):Date {
        var noOfDays:int = num_days_before;
        var mois:Number;
        var annee:Number;
        if (_currentMois == 0) {
            annee = _currentAnnee - 1;
            mois = 11;
        } else {
            annee = _currentAnnee;
            mois = _currentMois;
        }
        var lastDay:Date = new Date(annee, mois, 1);
        lastDay.setTime(lastDay.time - (noOfDays * 24 * 60 * 60 * 1000));
        return lastDay;
    }

    private function getSelectedMonthDate(num_day:Number):Date {
        var noOfDays:int = num_day;
        var specific_day:Date = new Date(_currentFirstDate.fullYear, _currentFirstDate.month, 1);
        specific_day.date += noOfDays;
        return specific_day;
    }

    private function getNextMonthDate(num_day:Number):Date {
        var noOfDays:int = num_day;
        var mois:Number;
        var annee:Number;
        if (_currentMois == 11) {
            annee = _currentAnnee + 1;
            mois = 0;
        } else {
            annee = _currentAnnee;
            mois = _currentMois + 1;
        }
        var specific_day:Date = new Date(annee, mois, 1);
        specific_day.date += noOfDays;
        return specific_day;
    }

    private function isLeapYear(currentyear:Number):Boolean {
        var yearDev:Number = currentyear / 4;
        var yearDevLength:Number = yearDev.toString().split(".").length;
        return yearDevLength != 1 ? false : true;
    }

    // retourne Jeudi 1er Décembre
    private function formatDDay(date:Date):String {
        var jour_index:Array = ["Dimanche", "Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi", "Samedi"];
        var today:Array = DateUtils.isoToStringFrenchDate(DateUtils.dateToIso(date)).split(" ");
        var jour:Number = Number(today[0]) * 1;
        var mois:String = String(today[1].substring(0, 1)).toUpperCase() + today[1].substr(1);
        var str:String = jour_index[date.day] + " " + jour + " " + mois;
        return str;

    }
}
}

import com.greensock.TweenLite;
import com.greensock.easing.Power2;

import fr.opendo.tools.Const;

class DateCell extends DatePickerCellView {

    private var _date:Date;
    private var _selected:Boolean;

    public function DateCell(date:Date, isToday:Boolean = false) {
        _date = date;
        $select.alpha = 0;
        $label.text = String(date.date);
        if (isToday) {
            $label.textColor = 0xEF316B;
        } else {
            $label.textColor = 0xFFFFFF;
        }
        $label.alpha = 0.5;
        $dataIn.visible = false;
    }

    public function select(value:Boolean):void {
        _selected = value;
        TweenLite.killTweensOf($select);
        if (_selected) {
            TweenLite.to($select, Const.ANIM_DURATION, {alpha: 1});
            TweenLite.to(this, Const.ANIM_DURATION, {scaleX: 1.5, scaleY: 1.5, ease: Power2.easeOut});
        } else {
            TweenLite.to($select, Const.ANIM_DURATION, {alpha: 0});
            TweenLite.to(this, Const.ANIM_DURATION, {scaleX: 1, scaleY: 1, ease: Power2.easeOut});
        }
    }

    public function get date():Date {
        return _date;
    }

    public function get selected():Boolean {
        return _selected;
    }

    public function setDataIn():void {
        buttonMode = true;
        mouseChildren = false;
        $dataIn.visible = true;
        $label.alpha = 1;
    }

}