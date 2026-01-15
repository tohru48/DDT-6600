package trainer.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.PlayerManager;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import flash.utils.setTimeout;
   import trainer.controller.WeakGuildManager;
   import trainer.data.ArrowType;
   import trainer.data.Step;
   
   public class NewHandContainer
   {
      
      private static var _instance:NewHandContainer;
      
      private var _arrows:Dictionary;
      
      private var _movies:Dictionary;
      
      public function NewHandContainer(enforcer:NewHandContainerEnforcer)
      {
         super();
         this._arrows = new Dictionary();
         this._movies = new Dictionary();
      }
      
      public static function get Instance() : NewHandContainer
      {
         if(!_instance)
         {
            _instance = new NewHandContainer(new NewHandContainerEnforcer());
         }
         return _instance;
      }
      
      public function showArrow(id:int, rotation:int, arrowPos:*, tip:String = "", tipPos:String = "", con:DisplayObjectContainer = null, delay:int = 0, isFarmGuild:Boolean = false, beadLeadArrowPos:Point = null, beadLeadTxtPos:Point = null) : void
      {
         var arPos:Point = null;
         var arrow:MovieClip = null;
         var mcTip:MovieClip = null;
         var tPos:Point = null;
         if(this.hasArrow(id))
         {
            this.clearArrow(id);
         }
         if(id != ArrowType.HORSE_GUIDE && id != ArrowType.HORSE_GUIDE2 && id != ArrowType.BEAD_GUIDE)
         {
            if(!isFarmGuild)
            {
               if(!WeakGuildManager.Instance.switchUserGuide || PlayerManager.Instance.Self.IsWeakGuildFinish(Step.OLD_PLAYER))
               {
                  return;
               }
            }
         }
         var obj:Object = {};
         if(arrowPos is Point)
         {
            arPos = arrowPos;
         }
         else
         {
            arPos = ComponentFactory.Instance.creatCustomObject(arrowPos);
         }
         arrow = ClassUtils.CreatInstance("asset.trainer.TrainerArrowAsset");
         arrow.mouseChildren = false;
         arrow.mouseEnabled = false;
         arrow.rotation = rotation;
         arrow.x = arPos.x;
         arrow.y = arPos.y;
         if(Boolean(beadLeadArrowPos))
         {
            arrow.x = beadLeadArrowPos.x;
            arrow.y = beadLeadArrowPos.y;
         }
         if(Boolean(con))
         {
            con.addChild(arrow);
         }
         else
         {
            LayerManager.Instance.addToLayer(arrow,LayerManager.GAME_UI_LAYER,false,LayerManager.NONE_BLOCKGOUND);
         }
         obj["arrow"] = arrow;
         if(tip != "")
         {
            mcTip = ClassUtils.CreatInstance(tip);
            mcTip.mouseChildren = false;
            mcTip.mouseEnabled = false;
            if(tipPos != "")
            {
               tPos = ComponentFactory.Instance.creatCustomObject(tipPos);
               mcTip.x = tPos.x;
               mcTip.y = tPos.y;
            }
            if(Boolean(beadLeadTxtPos))
            {
               mcTip.x = beadLeadTxtPos.x;
               mcTip.y = beadLeadTxtPos.y;
            }
            if(Boolean(con))
            {
               con.addChild(mcTip);
            }
            else
            {
               LayerManager.Instance.addToLayer(mcTip,LayerManager.GAME_UI_LAYER,false,LayerManager.NONE_BLOCKGOUND);
            }
            obj["tip"] = mcTip;
         }
         this._arrows[id] = obj;
         if(delay > 0)
         {
            setTimeout(this.clearArrow,delay,id);
         }
      }
      
      public function clearArrowByID(id:int) : void
      {
         var i:String = null;
         if(id == -1)
         {
            for(i in this._arrows)
            {
               this.clearArrow(int(i));
            }
         }
         else
         {
            this.clearArrow(id);
         }
      }
      
      public function hasArrow(id:int) : Boolean
      {
         return this._arrows[id] != null;
      }
      
      public function showMovie(styleName:String, pos:String = "") : void
      {
         var mc:MovieClip = null;
         var p:Point = null;
         if(Boolean(this._movies[styleName]))
         {
            throw new Error("Already has a arrow with this id!");
         }
         mc = ClassUtils.CreatInstance(styleName);
         mc.mouseChildren = false;
         mc.mouseEnabled = false;
         if(pos != "")
         {
            p = ComponentFactory.Instance.creatCustomObject(pos);
            mc.x = p.x;
            mc.y = p.y;
         }
         LayerManager.Instance.addToLayer(mc,LayerManager.GAME_DYNAMIC_LAYER,false,LayerManager.NONE_BLOCKGOUND);
         this._movies[styleName] = mc;
      }
      
      public function hideMovie(styleName:String) : void
      {
         var s:String = null;
         if(styleName == "-1")
         {
            for(s in this._movies)
            {
               this.clearMovie(s);
            }
         }
         else
         {
            this.clearMovie(styleName);
         }
      }
      
      private function clearArrow(id:int) : void
      {
         var obj:Object = this._arrows[id];
         if(Boolean(obj))
         {
            ObjectUtils.disposeObject(obj["arrow"]);
            ObjectUtils.disposeObject(obj["tip"]);
         }
         delete this._arrows[id];
      }
      
      private function clearMovie(styleName:String) : void
      {
         ObjectUtils.disposeObject(this._movies[styleName]);
         delete this._movies[styleName];
      }
      
      public function dispose() : void
      {
         _instance = null;
         this._arrows = null;
         this._movies = null;
      }
   }
}

class NewHandContainerEnforcer
{
   
   public function NewHandContainerEnforcer()
   {
      super();
   }
}
