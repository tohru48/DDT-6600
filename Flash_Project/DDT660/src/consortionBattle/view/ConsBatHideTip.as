package consortionBattle.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.ObjectUtils;
   import consortionBattle.ConsortiaBattleManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class ConsBatHideTip extends Sprite implements Disposeable
   {
      
      public static const SELECTED_CHANGE:String = "consBatHideTip_selected_change";
      
      private var _bg:ScaleBitmapImage;
      
      private var _sameScb:SelectedCheckButton;
      
      private var _tombScb:SelectedCheckButton;
      
      private var _fightingScb:SelectedCheckButton;
      
      public function ConsBatHideTip()
      {
         super();
         this.initView();
         this.initEvent();
         this.updateTransform();
         this._sameScb.selected = ConsortiaBattleManager.instance.isHide(1);
         this._tombScb.selected = ConsortiaBattleManager.instance.isHide(2);
         this._fightingScb.selected = ConsortiaBattleManager.instance.isHide(3);
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("core.commonTipBg");
         this._sameScb = ComponentFactory.Instance.creatComponentByStylename("consortiaBattle.stripCheckBtn");
         this._sameScb.text = LanguageMgr.GetTranslation("ddt.consortiaBattle.hideTip.sameTxt");
         this._tombScb = ComponentFactory.Instance.creatComponentByStylename("consortiaBattle.stripCheckBtn");
         PositionUtils.setPos(this._tombScb,"consortiaBattle.hideTombScbPos");
         this._tombScb.text = LanguageMgr.GetTranslation("ddt.consortiaBattle.hideTip.tombTxt");
         this._fightingScb = ComponentFactory.Instance.creatComponentByStylename("consortiaBattle.stripCheckBtn");
         PositionUtils.setPos(this._fightingScb,"consortiaBattle.hideFightingScbPos");
         this._fightingScb.text = LanguageMgr.GetTranslation("ddt.consortiaBattle.hideTip.fightingTxt");
         addChild(this._bg);
         addChild(this._sameScb);
         addChild(this._tombScb);
         addChild(this._fightingScb);
      }
      
      private function initEvent() : void
      {
         this._sameScb.addEventListener(MouseEvent.CLICK,this.clickHandler,false,0,true);
         this._tombScb.addEventListener(MouseEvent.CLICK,this.clickHandler,false,0,true);
         this._fightingScb.addEventListener(MouseEvent.CLICK,this.clickHandler,false,0,true);
      }
      
      private function clickHandler(event:MouseEvent) : void
      {
         var tmpInt:int = 0;
         SoundManager.instance.play("008");
         var tmp:SelectedCheckButton = event.currentTarget as SelectedCheckButton;
         switch(tmp)
         {
            case this._sameScb:
               tmpInt = 1;
               break;
            case this._tombScb:
               tmpInt = 2;
               break;
            case this._fightingScb:
               tmpInt = 3;
               break;
            default:
               tmpInt = 1;
         }
         ConsortiaBattleManager.instance.changeHideRecord(tmpInt,tmp.selected);
         dispatchEvent(new Event(SELECTED_CHANGE));
      }
      
      public function hideAll() : void
      {
         this._sameScb.selected = true;
         this._tombScb.selected = true;
         this._fightingScb.selected = true;
         ConsortiaBattleManager.instance.changeHideRecord(1,true);
         ConsortiaBattleManager.instance.changeHideRecord(2,true);
         ConsortiaBattleManager.instance.changeHideRecord(3,true);
      }
      
      public function showAll() : void
      {
         this._sameScb.selected = false;
         this._tombScb.selected = false;
         this._fightingScb.selected = false;
         ConsortiaBattleManager.instance.changeHideRecord(1,false);
         ConsortiaBattleManager.instance.changeHideRecord(2,false);
         ConsortiaBattleManager.instance.changeHideRecord(3,false);
      }
      
      private function updateTransform() : void
      {
         var maxWidth:int = Math.max(this._sameScb.width,this._tombScb.width,this._fightingScb.width);
         this._bg.width = this._sameScb.x + maxWidth + 15;
         this._bg.height = this._fightingScb.y + this._fightingScb.height + 11;
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._sameScb = null;
         this._tombScb = null;
         this._fightingScb = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

