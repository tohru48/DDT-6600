package wantstrong.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.PlayerManager;
   import flash.display.Sprite;
   import wantstrong.data.WantStrongMenuData;
   
   public class WantStrongContentView extends Sprite implements Disposeable
   {
      
      private var _content:VBox;
      
      private var _detail:WantStrongDetail;
      
      private var _scrollPanel:ScrollPanel;
      
      public function WantStrongContentView()
      {
         super();
         this.initUI();
         this.initEvent();
      }
      
      private function initEvent() : void
      {
      }
      
      private function initUI() : void
      {
         this._content = ComponentFactory.Instance.creatComponentByStylename("wantstrong.ActivityState.Vbox");
         this._scrollPanel = ComponentFactory.Instance.creatComponentByStylename("wantstrong.ActivityDetailList");
         this._scrollPanel.setView(this._content);
         addChild(this._scrollPanel);
      }
      
      public function setData(val:* = null) : void
      {
         var item:WantStrongMenuData = null;
         var wantStrongDetail:WantStrongDetail = null;
         for each(item in val)
         {
            if(PlayerManager.Instance.Self.Grade >= item.needLevel)
            {
               wantStrongDetail = ComponentFactory.Instance.creatCustomObject("wantstrong.WantStrongDetail",[item]);
               this._content.addChild(wantStrongDetail);
            }
         }
         this._scrollPanel.invalidateViewport();
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._content);
         this._content = null;
         ObjectUtils.disposeObject(this._scrollPanel);
         this._scrollPanel = null;
      }
   }
}

