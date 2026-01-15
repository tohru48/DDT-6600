package wantstrong.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   import wantstrong.data.WantStrongModel;
   
   public class WantStrongList extends Sprite implements Disposeable
   {
      
      private var _listMenu:WantStrongMenu;
      
      private var _model:WantStrongModel;
      
      public function WantStrongList(model:WantStrongModel)
      {
         super();
         this._model = model;
         this.createUI();
      }
      
      private function createUI() : void
      {
         this._listMenu = ComponentFactory.Instance.creatCustomObject("wantstrong.WantStrongMenu",[this._model]);
         addChild(this._listMenu);
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._listMenu = null;
      }
   }
}

