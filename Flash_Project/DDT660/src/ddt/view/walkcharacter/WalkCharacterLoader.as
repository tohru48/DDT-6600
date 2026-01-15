package ddt.view.walkcharacter
{
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.DisplayUtils;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.ItemManager;
   import ddt.view.character.ILayer;
   import flash.display.BitmapData;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class WalkCharacterLoader extends EventDispatcher implements Disposeable
   {
      
      public static const CellCharaterWidth:int = 120;
      
      public static const CellCharaterHeight:int = 175;
      
      private static const standFrams:Array = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1];
      
      private static const backFrame:Array = [3];
      
      private static const walkFrontFrame:Array = [3,3,3,4,4,4,5,5,5,6,6,6,7,7,7,8,8,8];
      
      private static const walkBackFrame:Array = [10,10,10,11,11,11,12,12,12,13,13,13,14,14,14];
      
      public static const FrameLabels:Array = [{
         "frame":1,
         "name":"stand"
      },{
         "frame":standFrams.length - 1,
         "name":"gotoAndPlay(stand)"
      },{
         "frame":standFrams.length,
         "name":"back"
      },{
         "frame":standFrams.length + backFrame.length,
         "name":"walkfront"
      },{
         "frame":standFrams.length + backFrame.length + walkFrontFrame.length - 1,
         "name":"gotoAndPlay(walkfront)"
      },{
         "frame":standFrams.length + backFrame.length + walkFrontFrame.length,
         "name":"walkback"
      },{
         "frame":standFrams.length + backFrame.length + walkFrontFrame.length + walkBackFrame.length - 1,
         "name":"gotoAndPlay(walkback)"
      }];
      
      public static const UsedFrame:Array = standFrams.concat(backFrame,walkFrontFrame,walkBackFrame);
      
      public static const Stand:String = "stand";
      
      public static const Back:String = "back";
      
      public static const WalkFront:String = "walkfront";
      
      public static const WalkBack:String = "walkback";
      
      private var _resultBitmapData:BitmapData;
      
      private var _layers:Vector.<WalkCharaterLayer>;
      
      private var _playerInfo:PlayerInfo;
      
      private var _recordStyle:Array;
      
      private var _recordColor:Array;
      
      private var _clothPath:String;
      
      public function WalkCharacterLoader(info:PlayerInfo, clothpath:String)
      {
         super();
         this._clothPath = clothpath;
         this._playerInfo = info;
      }
      
      public function load() : void
      {
         this._layers = new Vector.<WalkCharaterLayer>();
         if(this._playerInfo == null || this._playerInfo.Style == null)
         {
            return;
         }
         this.initLoaders();
         var layerCount:int = int(this._layers.length);
         for(var i:int = 0; i < layerCount; i++)
         {
            this._layers[i].load(this.layerComplete);
         }
      }
      
      private function initLoaders() : void
      {
         this._layers = new Vector.<WalkCharaterLayer>();
         this._recordStyle = this._playerInfo.Style.split(",");
         this._recordColor = this._playerInfo.Colors.split(",");
         this._layers.push(new WalkCharaterLayer(ItemManager.Instance.getTemplateById(int(this._recordStyle[5].split("|")[0])),this._recordColor[5]));
         this._layers.push(new WalkCharaterLayer(ItemManager.Instance.getTemplateById(int(this._recordStyle[2].split("|")[0])),this._recordColor[2]));
         this._layers.push(new WalkCharaterLayer(ItemManager.Instance.getTemplateById(int(this._recordStyle[3].split("|")[0])),this._recordColor[3]));
         this._layers.push(new WalkCharaterLayer(ItemManager.Instance.getTemplateById(int(this._recordStyle[4].split("|")[0])),this._recordColor[4],1,this._playerInfo.Sex,this._clothPath));
         this._layers.push(new WalkCharaterLayer(ItemManager.Instance.getTemplateById(int(this._recordStyle[4].split("|")[0])),this._recordColor[4],2,this._playerInfo.Sex,this._clothPath));
      }
      
      private function layerComplete(layer:ILayer) : void
      {
         var isAllLayerComplete:Boolean = true;
         for(var i:int = 0; i < this._layers.length; i++)
         {
            if(!this._layers[i].isComplete)
            {
               isAllLayerComplete = false;
            }
         }
         if(isAllLayerComplete)
         {
            this.loadComplete();
         }
      }
      
      private function loadComplete() : void
      {
         var eff:BitmapData = null;
         var face:BitmapData = null;
         var hair:BitmapData = null;
         var clothFront:BitmapData = null;
         var clothBack:BitmapData = null;
         var drawFrame:Function = function(frameIndex:int, clothIndex:int, hairIndex:int, faceIndex:int, effIndex:int, headDownY:int = 0):void
         {
            var rectangle:Rectangle = new Rectangle();
            rectangle.width = CellCharaterWidth;
            rectangle.height = CellCharaterHeight;
            var point:Point = new Point();
            point.x = frameIndex * CellCharaterWidth;
            if(clothIndex <= 6)
            {
               rectangle.x = faceIndex * CellCharaterWidth;
               rectangle.y = 0;
               point.y = headDownY;
               _resultBitmapData.copyPixels(face,rectangle,point,null,null,true);
               rectangle.x = hairIndex * CellCharaterWidth;
               _resultBitmapData.copyPixels(hair,rectangle,point,null,null,true);
               rectangle.x = effIndex * CellCharaterWidth;
               _resultBitmapData.copyPixels(eff,rectangle,point,null,null,true);
               rectangle.x = clothIndex * CellCharaterWidth;
               point.y = 0;
               _resultBitmapData.copyPixels(clothFront,rectangle,point,null,null,true);
            }
            else
            {
               rectangle.x = (clothIndex - 7) * CellCharaterWidth;
               rectangle.y = CellCharaterHeight;
               _resultBitmapData.copyPixels(clothBack,rectangle,point,null,null,true);
               rectangle.x = faceIndex * CellCharaterWidth;
               rectangle.y = 0;
               point.y = headDownY;
               _resultBitmapData.copyPixels(face,rectangle,point,null,null,true);
               rectangle.x = hairIndex * CellCharaterWidth;
               _resultBitmapData.copyPixels(hair,rectangle,point,null,null,true);
               rectangle.x = effIndex * CellCharaterWidth;
               _resultBitmapData.copyPixels(eff,rectangle,point,null,null,true);
            }
         };
         eff = DisplayUtils.getDisplayBitmapData(this._layers[2]);
         face = DisplayUtils.getDisplayBitmapData(this._layers[0]);
         hair = DisplayUtils.getDisplayBitmapData(this._layers[1]);
         clothFront = DisplayUtils.getDisplayBitmapData(this._layers[3]);
         clothBack = DisplayUtils.getDisplayBitmapData(this._layers[4]);
         this._resultBitmapData = new BitmapData(CellCharaterWidth * 15,CellCharaterHeight,true,16711680);
         drawFrame(0,0,0,0,0);
         drawFrame(1,0,1,1,1);
         drawFrame(2,7,2,2,2);
         drawFrame(3,1,0,0,0);
         drawFrame(4,2,0,0,0);
         drawFrame(5,3,0,0,0,2);
         drawFrame(6,4,0,0,0);
         drawFrame(7,5,0,0,0);
         drawFrame(8,6,0,0,0,2);
         drawFrame(9,8,2,2,2);
         drawFrame(10,9,2,2,2);
         drawFrame(11,10,2,2,2,2);
         drawFrame(12,11,2,2,2);
         drawFrame(13,12,2,2,2);
         drawFrame(14,13,2,2,2,2);
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      public function get content() : BitmapData
      {
         return this._resultBitmapData;
      }
      
      public function dispose() : void
      {
         this._resultBitmapData.dispose();
         for(var i:int = 0; i < this._layers.length; i++)
         {
            this._layers[i].dispose();
         }
         this._layers = null;
         this._recordStyle = null;
         this._recordColor = null;
         this._playerInfo = null;
      }
   }
}

