package ddt.view.tips
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class Battle extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _battle_txt:FilterFrameText;
      
      public function Battle(battle:int)
      {
         super();
         this.init();
         this.BattleNum = battle;
      }
      
      private function init() : void
      {
         this._bg = ComponentFactory.Instance.creat("asset.core.leveltip.BattleBg");
         this._battle_txt = ComponentFactory.Instance.creat("core.BattleTxt");
         addChild(this._bg);
         addChild(this._battle_txt);
      }
      
      public function set BattleNum(battleNum:int) : void
      {
         this._battle_txt.text = battleNum.toString();
      }
      
      public function dispose() : void
      {
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._battle_txt))
         {
            ObjectUtils.disposeObject(this._battle_txt);
         }
         this._battle_txt = null;
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

