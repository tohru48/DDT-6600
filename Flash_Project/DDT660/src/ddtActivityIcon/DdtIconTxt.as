package ddtActivityIcon
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import consortionBattle.view.ConsortiaBattleEntryBtn;
   import flash.display.Sprite;
   import worldboss.view.WorldBossIcon;
   
   public class DdtIconTxt extends Sprite
   {
      
      private var _txt:FilterFrameText;
      
      private var _isOver:Boolean;
      
      private var _sp:Sprite;
      
      private var _isOpen:Boolean;
      
      public function DdtIconTxt()
      {
         super();
         this.initView();
      }
      
      public function addActIcon(sp:Sprite) : void
      {
         this._sp = sp;
         if(sp is WorldBossIcon)
         {
            sp.y = 127;
            sp.x = 33;
            addChild(sp);
            return;
         }
         if(sp is ConsortiaBattleEntryBtn)
         {
            sp.x = 34;
            sp.y = 167;
            addChild(sp);
            return;
         }
         addChild(sp);
         sp.y = this._txt.y - sp.height;
         sp.x = 100 / 2 - sp.width / 2 + this._txt.x - 12;
         this.isOver = true;
      }
      
      public function resetPos() : void
      {
         this._sp.y = 0;
         this._sp.x = 0;
         this._txt.x = this._sp.x + this._sp.width / 2 - this._txt.width / 2;
         this._txt.y = this._sp.y + this._sp.height;
      }
      
      public function set isOver(bool:Boolean) : void
      {
         this._isOver = bool;
      }
      
      public function get isOver() : Boolean
      {
         return this._isOver;
      }
      
      public function set isOpen(bool:Boolean) : void
      {
         this._isOpen = bool;
      }
      
      public function get isOpen() : Boolean
      {
         return this._isOpen;
      }
      
      private function initView() : void
      {
         this._txt = ComponentFactory.Instance.creatComponentByStylename("activity.txt");
         addChild(this._txt);
      }
      
      public function setTxt(str:String) : void
      {
         this._txt.text = str;
      }
      
      public function resetTxt() : void
      {
         if(Boolean(this._txt))
         {
            this._txt.text = "";
         }
         this._isOver = false;
         this._isOpen = false;
         DdtActivityIconManager.Instance.isOneOpen = false;
         ObjectUtils.disposeObject(this._sp);
         this._sp = null;
      }
      
      public function dispose() : void
      {
         this._isOver = false;
         while(Boolean(numChildren))
         {
            ObjectUtils.disposeObject(getChildAt(0));
         }
         this._sp = null;
         this._txt = null;
      }
      
      public function get sp() : Sprite
      {
         return this._sp;
      }
   }
}

