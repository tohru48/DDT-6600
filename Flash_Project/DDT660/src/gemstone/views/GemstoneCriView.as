package gemstone.views
{
   import com.greensock.TweenLite;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SoundManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import gemstone.GemstoneManager;
   import gemstone.info.GemstListInfo;
   import gemstone.info.GemstonInitInfo;
   import gemstone.info.GemstoneStaticInfo;
   import gemstone.info.GemstoneUpGradeInfo;
   import gemstone.items.GemstoneContent;
   import gemstone.items.Item;
   import org.aswing.KeyboardManager;
   
   public class GemstoneCriView extends Sprite implements Disposeable
   {
      
      private static const ANGLE_P1:int = 90;
      
      private static const ANGLE_P2:int = 210;
      
      private static const ANGLE_P3:int = 330;
      
      private static const RADIUS:int = 38;
      
      private var maxLevel:int;
      
      public var data:GemstonInitInfo;
      
      public var staticDataList:Vector.<GemstoneStaticInfo>;
      
      public var place:int;
      
      private var _contArray:Vector.<GemstoneContent>;
      
      private var _centerP:Point;
      
      private var _item:Item;
      
      private var _point1:Point;
      
      private var _point2:Point;
      
      private var _point3:Point;
      
      private var _pointArray:Array;
      
      private var _startPointArr:Array;
      
      private var _funArray:Array;
      
      private var _func1:Function;
      
      private var _func2:Function;
      
      private var _func3:Function;
      
      private var _lightning:MovieClip;
      
      private var _bombo:MovieClip;
      
      private var _groudMc:MovieClip;
      
      private var _upGradeMc:MovieClip;
      
      private var _isLeft:Boolean = false;
      
      private var _index:int;
      
      private var _minGemstone:Array;
      
      private var _midGemstone:Array;
      
      private var _maxGemstone:Array;
      
      private var _curItem:GemstoneContent;
      
      public var curIndex:int;
      
      public var curInfo:GemstListInfo;
      
      public var curList:Vector.<GemstListInfo>;
      
      private var _info:GemstoneUpGradeInfo;
      
      private var _isAction:Boolean;
      
      private var curInfoList:Vector.<GemstListInfo>;
      
      private var PRICE:int = 10;
      
      public function GemstoneCriView()
      {
         var gemCont:GemstoneContent = null;
         var p:Point = null;
         this.maxLevel = GemstoneManager.Instance.curMaxLevel;
         this._centerP = new Point(0,0);
         super();
         this._pointArray = [];
         this._startPointArr = [];
         this._funArray = [];
         this._contArray = new Vector.<GemstoneContent>();
         for(var i:int = 0; i < 3; i++)
         {
            gemCont = new GemstoneContent(i,this._centerP);
            gemCont.id = i + 1;
            addChild(gemCont);
            this._contArray.push(gemCont);
            p = new Point(gemCont.x,gemCont.y);
            this._startPointArr.push(p);
         }
         this._item = new Item();
         this._item.x = -105;
         this._item.y = -105;
         addChild(this._item);
         this._func1 = this.completedHander1;
         this._func2 = this.completedHander2;
         this._func3 = this.completedHander3;
         this._funArray.push(this._func1);
         this._funArray.push(this._func2);
         this._funArray.push(this._func3);
         this._point1 = new Point();
         this._point1.x = Math.round(this._centerP.x + Math.cos(ANGLE_P1 * (Math.PI / 180)) * RADIUS);
         this._point1.y = Math.round(this._centerP.y - Math.sin(ANGLE_P1 * (Math.PI / 180)) * RADIUS);
         this._pointArray.push(this._point1);
         this._point2 = new Point();
         this._point2.x = Math.round(this._centerP.x + Math.cos(ANGLE_P2 * (Math.PI / 180)) * RADIUS);
         this._point2.y = Math.round(this._centerP.y - Math.sin(ANGLE_P2 * (Math.PI / 180)) * RADIUS);
         this._pointArray.push(this._point2);
         this._point3 = new Point();
         this._point3.x = Math.round(this._centerP.x + Math.cos(ANGLE_P3 * (Math.PI / 180)) * RADIUS);
         this._point3.y = Math.round(this._centerP.y - Math.sin(ANGLE_P3 * (Math.PI / 180)) * RADIUS);
         this._pointArray.push(this._point3);
         this._lightning = ComponentFactory.Instance.creat("gemstone.shandian");
         this._lightning.x = -44;
         this._lightning.y = -38;
         this._lightning.gotoAndStop(this._lightning.totalFrames);
         this._lightning.visible = false;
         addChild(this._lightning);
         this._bombo = ComponentFactory.Instance.creat("gemstone.bombo");
         this._bombo.x = -76;
         this._bombo.y = -78;
         this._bombo.gotoAndStop(this._bombo.totalFrames);
         this._bombo.visible = false;
         addChild(this._bombo);
         this._groudMc = ComponentFactory.Instance.creat("gemstone.groudMC");
         this._groudMc.x = -39;
         this._groudMc.y = -32;
         this._groudMc.gotoAndStop(this._groudMc.totalFrames);
         this._groudMc.visible = false;
         addChild(this._groudMc);
         this._upGradeMc = ComponentFactory.Instance.creat("gemstone.upGradeMc");
         this._upGradeMc.gotoAndStop(this._upGradeMc.totalFrames);
         this._upGradeMc.x = -76;
         this._upGradeMc.y = 23;
         this._upGradeMc.visible = false;
         addChild(this._upGradeMc);
      }
      
      public function upDataIcon(info:ItemTemplateInfo) : void
      {
         this._item.upDataIcon(info);
      }
      
      public function initFigSkin(str:String) : void
      {
         this._contArray[0].loadSikn(str);
         this._contArray[1].loadSikn(str);
         this._contArray[2].loadSikn(str);
         this._contArray[0].selAlphe(0.4);
         this._contArray[1].selAlphe(0.4);
         this._contArray[2].selAlphe(0.4);
      }
      
      public function resetGemstoneList(list:Vector.<GemstListInfo>) : void
      {
         var i:int = 0;
         var total:int = 0;
         var len:int = int(list.length);
         for(i = 0; i < len; i++)
         {
            this._contArray[i].x = this._startPointArr[i].x;
            this._contArray[i].y = this._startPointArr[i].y;
         }
         for(var t_j:int = 0; t_j < 3; t_j++)
         {
            if(list[t_j].place == 0)
            {
               this._contArray[0].info = list[t_j];
               if(list[t_j].level > 0)
               {
                  this._contArray[0].selAlphe(1);
               }
               else
               {
                  this._contArray[0].selAlphe(0.4);
               }
               this._contArray[0].upDataLevel();
            }
            else if(list[t_j].place == 1)
            {
               this._contArray[1].info = list[t_j];
               if(list[t_j].level > 0)
               {
                  this._contArray[1].selAlphe(1);
               }
               else
               {
                  this._contArray[1].selAlphe(0.4);
               }
               this._contArray[1].upDataLevel();
            }
            else if(list[t_j].place == 2)
            {
               this._contArray[2].info = list[t_j];
               if(list[t_j].level > 0)
               {
                  this._contArray[2].selAlphe(1);
               }
               else
               {
                  this._contArray[2].selAlphe(0.4);
               }
               this._contArray[2].upDataLevel();
               this.curInfo = list[t_j];
               this._curItem = this._contArray[2];
            }
         }
         this._item.updataInfo(list);
         this.curIndex = this.curInfo.place;
         var level:int = this.curInfo.level;
         this.setCurInfo(list[0].fightSpiritId,level);
         if(level >= this.maxLevel)
         {
            level = this.maxLevel;
            total = this.staticDataList[level].Exp - this.staticDataList[level - 1].Exp;
            GemstoneUpView(parent).expBar.initBar(total,total,true);
            return;
         }
         level++;
         total = this.staticDataList[level].Exp - this.staticDataList[level - 1].Exp;
         GemstoneUpView(parent).expBar.initBar(this.curInfo.exp,total);
      }
      
      private function setCurInfo(id:int, level:int) : void
      {
         var pro1:int = 0;
         var pro2:int = 0;
         var pro3:int = 0;
         var obj:Object = new Object();
         obj.curLve = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.pdescriptTxt1") + level;
         obj.levHe = int(this._contArray[0].info.level) + int(this._contArray[1].info.level) + int(this._contArray[2].info.level);
         if(id == GemstoneManager.ID1)
         {
            pro1 = this.staticDataList[this._contArray[0].info.level].attack;
            pro2 = this.staticDataList[this._contArray[1].info.level].attack;
            pro3 = this.staticDataList[this._contArray[2].info.level].attack;
            if(level >= this.maxLevel)
            {
               level = this.maxLevel;
            }
            obj.upGrdPro = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.pdescriptTxt3") + this.staticDataList[level].attack;
         }
         else if(id == GemstoneManager.ID2)
         {
            pro1 = this.staticDataList[this._contArray[0].info.level].defence;
            pro2 = this.staticDataList[this._contArray[1].info.level].defence;
            pro3 = this.staticDataList[this._contArray[2].info.level].defence;
            if(level >= this.maxLevel)
            {
               level = this.maxLevel;
            }
            obj.upGrdPro = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.pdescriptTxt3") + this.staticDataList[level].defence;
         }
         else if(id == GemstoneManager.ID3)
         {
            pro1 = this.staticDataList[this._contArray[0].info.level].agility;
            pro2 = this.staticDataList[this._contArray[1].info.level].agility;
            pro3 = this.staticDataList[this._contArray[2].info.level].agility;
            if(level >= this.maxLevel)
            {
               level = this.maxLevel;
            }
            obj.upGrdPro = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.pdescriptTxt3") + this.staticDataList[level].agility;
         }
         else if(id == GemstoneManager.ID4)
         {
            pro1 = this.staticDataList[this._contArray[0].info.level].luck;
            pro2 = this.staticDataList[this._contArray[1].info.level].luck;
            pro3 = this.staticDataList[this._contArray[2].info.level].luck;
            if(level >= this.maxLevel)
            {
               level = this.maxLevel;
            }
            obj.upGrdPro = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.pdescriptTxt3") + this.staticDataList[level].luck;
         }
         else if(id == GemstoneManager.ID5)
         {
            pro1 = this.staticDataList[this._contArray[0].info.level].blood;
            pro2 = this.staticDataList[this._contArray[1].info.level].blood;
            pro3 = this.staticDataList[this._contArray[2].info.level].blood;
            if(level >= this.maxLevel)
            {
               level = this.maxLevel;
            }
            obj.upGrdPro = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.pdescriptTxt3") + this.staticDataList[level].blood;
         }
         obj.proHe = pro1 + pro2 + pro3;
         (parent as GemstoneUpView).upDataCur(obj);
      }
      
      public function upGradeAction(info:GemstoneUpGradeInfo) : void
      {
         var level:int = 0;
         var i:int = 0;
         var total1:int = 0;
         if(info.list.length == 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.gemstone.curInfo.notEquip"));
            GemstoneManager.Instance.gemstoneFrame.getMaskMc().visible = false;
            KeyboardManager.getInstance().isStopDispatching = false;
            return;
         }
         this._info = info;
         if(this._info.isMaxLevel)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.gemstone.curInfo.maxLevel"));
            GemstoneManager.Instance.gemstoneFrame.getMaskMc().visible = false;
            return;
         }
         if(this.curInfo == null)
         {
            level = 0;
         }
         else
         {
            level = this.curInfo.level;
         }
         if(!info.isUp)
         {
            if(!info.isFall)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.gemstone.curInfo.notfit"));
               GemstoneManager.Instance.gemstoneFrame.getMaskMc().visible = false;
               return;
            }
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.gemstone.curInfo.upgradeExp",info.num * this.PRICE));
            for(i = 0; i < 3; i++)
            {
               if(info.list[i].place == 2)
               {
                  if(Boolean(this.curInfo))
                  {
                     GemstoneManager.Instance.gemstoneFrame.getMaskMc().visible = false;
                     this.curInfo = info.list[i];
                  }
                  else
                  {
                     this.curInfo = new GemstListInfo();
                     this.curInfo = info.list[i];
                  }
                  break;
               }
            }
            level++;
            if(level >= this.maxLevel)
            {
               level = this.maxLevel;
            }
            total1 = this.staticDataList[level].Exp - this.staticDataList[level - 1].Exp;
            GemstoneManager.Instance.expBar.initBar(this.curInfo.exp,total1);
            return;
         }
         this._isLeft = true;
         this._isAction = true;
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.gemstone.curInfo.succe"));
         ++this._curItem.info.level;
         level = this._curItem.info.level;
         this._curItem.upDataLevel();
         this._upGradeMc.visible = true;
         this._upGradeMc.gotoAndPlay(1);
         var total:int = this.staticDataList[level].Exp - this.staticDataList[level - 1].Exp;
         GemstoneManager.Instance.expBar.initBar(total,total);
         addEventListener(Event.ENTER_FRAME,this.enterframeHander);
      }
      
      private function init() : void
      {
         var arr:Array = new Array();
         for(var t_i:int = 0; t_i < 3; t_i++)
         {
            this._contArray[t_i].x = this._startPointArr[t_i].x;
            this._contArray[t_i].y = this._startPointArr[t_i].y;
         }
         for(var t_j:int = 0; t_j < 3; t_j++)
         {
            if(this._info.list[t_j].place == 0)
            {
               this._contArray[0].info = this._info.list[t_j];
               if(this._info.list[t_j].level > 0)
               {
                  this._contArray[0].selAlphe(1);
               }
               else
               {
                  this._contArray[0].selAlphe(0.4);
               }
               this._contArray[0].upDataLevel();
            }
            else if(this._info.list[t_j].place == 1)
            {
               this._contArray[1].info = this._info.list[t_j];
               if(this._info.list[t_j].level > 0)
               {
                  this._contArray[1].selAlphe(1);
               }
               else
               {
                  this._contArray[1].selAlphe(0.4);
               }
               this._contArray[1].upDataLevel();
            }
            else if(this._info.list[t_j].place == 2)
            {
               this._contArray[2].info = this._info.list[t_j];
               if(this._info.list[t_j].level > 0)
               {
                  this._contArray[2].selAlphe(1);
               }
               else
               {
                  this._contArray[2].selAlphe(0.4);
               }
               this._contArray[2].upDataLevel();
               this.curInfo = this._info.list[t_j];
            }
         }
         this.curInfoList = this._info.list;
         var level:int = this.curInfo.level;
         this.setCurInfo(this.curInfo.fightSpiritId,level);
         this._item.updataInfo(this.curInfoList);
         level++;
         if(level >= this.maxLevel)
         {
            level = this.maxLevel;
         }
         var total:int = this.staticDataList[level].Exp - this.staticDataList[level - 1].Exp;
         GemstoneManager.Instance.expBar.initBar(this.curInfo.exp,total);
         GemstoneManager.Instance.gemstoneFrame.getMaskMc().visible = false;
      }
      
      public function gemstoAction() : void
      {
         var i:int = 0;
         var j:int = 0;
         var k:int = 0;
         var t_i:int = 0;
         var t_j:int = 0;
         var t_k:int = 0;
         var index1:int = 0;
         var cLen:int = int(this._contArray.length);
         if(!this._isLeft)
         {
            if(this._contArray[0].x == this._startPointArr[2].x)
            {
               for(i = 0; i < 3; i++)
               {
                  if(i == 0)
                  {
                     index1 = 1;
                  }
                  else if(i == 1)
                  {
                     index1 = 2;
                  }
                  else if(i == 2)
                  {
                     index1 = 0;
                  }
                  TweenLite.to(this._contArray[i],0.5,{
                     "x":this._pointArray[index1].x,
                     "y":this._pointArray[index1].y,
                     "onComplete":this._funArray[i]
                  });
               }
            }
            else if(this._contArray[0].x == this._startPointArr[1].x)
            {
               for(j = 0; j < 3; j++)
               {
                  index1 = j;
                  TweenLite.to(this._contArray[j],0.5,{
                     "x":this._pointArray[index1].x,
                     "y":this._pointArray[index1].y,
                     "onComplete":this._funArray[j]
                  });
               }
            }
            else if(this._contArray[0].x == this._startPointArr[0].x)
            {
               for(k = 0; k < 3; k++)
               {
                  if(k == 0)
                  {
                     index1 = 2;
                  }
                  else if(k == 1)
                  {
                     index1 = 0;
                  }
                  else if(k == 2)
                  {
                     index1 = 1;
                  }
                  TweenLite.to(this._contArray[k],0.5,{
                     "x":this._pointArray[index1].x,
                     "y":this._pointArray[index1].y,
                     "onComplete":this._funArray[k]
                  });
               }
            }
            return;
         }
         if(this._contArray[0].x == this._startPointArr[0].x)
         {
            for(t_i = 0; t_i < 3; t_i++)
            {
               index1 = t_i;
               TweenLite.to(this._contArray[t_i],0.5,{
                  "x":this._pointArray[index1].x,
                  "y":this._pointArray[index1].y,
                  "onComplete":this._funArray[t_i]
               });
            }
         }
         else if(this._contArray[0].x == this._startPointArr[1].x)
         {
            for(t_j = 0; t_j < 3; t_j++)
            {
               index1 = t_j + 1;
               if(index1 > 2)
               {
                  index1 = 0;
               }
               TweenLite.to(this._contArray[t_j],0.5,{
                  "x":this._pointArray[index1].x,
                  "y":this._pointArray[index1].y,
                  "onComplete":this._funArray[t_j]
               });
            }
         }
         else if(this._contArray[0].x == this._startPointArr[2].x)
         {
            for(t_k = 0; t_k < 3; t_k++)
            {
               if(t_k == 0)
               {
                  index1 = 2;
               }
               else
               {
                  index1 = t_k - 1;
               }
               TweenLite.to(this._contArray[t_k],0.5,{
                  "x":this._pointArray[index1].x,
                  "y":this._pointArray[index1].y,
                  "onComplete":this._funArray[t_k]
               });
            }
         }
      }
      
      private function completedHander1() : void
      {
         if(!this._isLeft)
         {
            if(this._contArray[0].x == this._pointArray[0].x)
            {
               TweenLite.to(this._contArray[0],0.5,{
                  "x":this._startPointArr[0].x,
                  "y":this._startPointArr[0].y,
                  "onComplete":this.lightningPlay
               });
            }
            else if(this._contArray[0].x == this._pointArray[2].x)
            {
               TweenLite.to(this._contArray[0],0.5,{
                  "x":this._startPointArr[2].x,
                  "y":this._startPointArr[2].y,
                  "onComplete":this.lightningPlay
               });
            }
            else if(this._contArray[0].x == this._pointArray[1].x)
            {
               TweenLite.to(this._contArray[0],0.5,{
                  "x":this._startPointArr[1].x,
                  "y":this._startPointArr[1].y,
                  "onComplete":this.lightningPlay
               });
            }
            return;
         }
         if(this._contArray[0].x == this._pointArray[0].x)
         {
            TweenLite.to(this._contArray[0],0.5,{
               "x":this._startPointArr[1].x,
               "y":this._startPointArr[1].y,
               "onComplete":this.lightningPlay
            });
         }
         else if(this._contArray[0].x == this._pointArray[1].x)
         {
            TweenLite.to(this._contArray[0],0.5,{
               "x":this._startPointArr[2].x,
               "y":this._startPointArr[2].y,
               "onComplete":this.lightningPlay
            });
         }
         else if(this._contArray[0].x == this._pointArray[2].x)
         {
            TweenLite.to(this._contArray[0],0.5,{
               "x":this._startPointArr[0].x,
               "y":this._startPointArr[0].y,
               "onComplete":this.lightningPlay
            });
         }
      }
      
      private function lightningPlay() : void
      {
         if(!this._lightning)
         {
            return;
         }
         this._lightning.visible = true;
         this._lightning.gotoAndPlay(1);
         SoundManager.instance.stop("169");
         SoundManager.instance.stop("170");
         SoundManager.instance.play("168");
      }
      
      private function enterframeHander(e:Event) : void
      {
         var total:int = 0;
         var len:int = 0;
         var i:int = 0;
         var level:int = 0;
         if(this._upGradeMc.currentFrame == this._upGradeMc.totalFrames - 1)
         {
            this._upGradeMc.visible = false;
            this._upGradeMc.gotoAndStop(this._upGradeMc.totalFrames);
            SoundManager.instance.stop("170");
            SoundManager.instance.play("169");
            len = int(this._contArray.length);
            for(i = 0; i < len; i++)
            {
               if(this._contArray[i].info.level > 0)
               {
                  this._contArray[i].selAlphe(1);
                  this._contArray[i].upDataLevel();
               }
            }
            if(this._isAction)
            {
               this.gemstoAction();
            }
            else
            {
               level = this.curInfo.level;
               if(level >= this.maxLevel)
               {
                  level = this.maxLevel;
                  total = this.staticDataList[level].Exp - this.staticDataList[level - 1].Exp;
                  GemstoneManager.Instance.expBar.initBar(total,total,true);
                  GemstoneManager.Instance.gemstoneFrame.getMaskMc().visible = false;
                  return;
               }
               this.setCurInfo(this.curInfo.fightSpiritId,level);
               level++;
               total = this.staticDataList[level].Exp - this.staticDataList[level - 1].Exp;
               GemstoneManager.Instance.expBar.initBar(0,total);
               GemstoneManager.Instance.gemstoneFrame.getMaskMc().visible = false;
            }
         }
         if(this._lightning.currentFrame == this._lightning.totalFrames - 1)
         {
            this._lightning.visible = false;
            this._lightning.gotoAndStop(this._lightning.totalFrames);
            this._bombo.visible = true;
            this._bombo.gotoAndPlay(1);
            this._groudMc.visible = true;
            this._groudMc.gotoAndPlay(1);
         }
         if(this._groudMc.currentFrame == this._groudMc.totalFrames - 1)
         {
            this._groudMc.visible = false;
            this._groudMc.gotoAndStop(this._groudMc.totalFrames);
            this.init();
            removeEventListener(Event.ENTER_FRAME,this.enterframeHander);
         }
         if(this._bombo.currentFrame == this._bombo.totalFrames - 1)
         {
            this._bombo.visible = false;
            this._bombo.gotoAndStop(this._bombo.totalFrames);
         }
      }
      
      private function completedHander2() : void
      {
         if(!this._isLeft)
         {
            if(this._contArray[0].x == this._pointArray[0].x)
            {
               TweenLite.to(this._contArray[1],0.5,{
                  "x":this._startPointArr[1].x,
                  "y":this._startPointArr[1].y
               });
            }
            else if(this._contArray[0].x == this._pointArray[2].x)
            {
               TweenLite.to(this._contArray[1],0.5,{
                  "x":this._startPointArr[0].x,
                  "y":this._startPointArr[0].y
               });
            }
            else if(this._contArray[0].x == this._pointArray[1].x)
            {
               TweenLite.to(this._contArray[1],0.5,{
                  "x":this._startPointArr[2].x,
                  "y":this._startPointArr[2].y
               });
            }
            return;
         }
         if(this._contArray[0].x == this._pointArray[0].x)
         {
            TweenLite.to(this._contArray[1],0.5,{
               "x":this._startPointArr[2].x,
               "y":this._startPointArr[2].y
            });
         }
         else if(this._contArray[0].x == this._pointArray[1].x)
         {
            TweenLite.to(this._contArray[1],0.5,{
               "x":this._startPointArr[0].x,
               "y":this._startPointArr[0].y
            });
         }
         else if(this._contArray[0].x == this._pointArray[2].x)
         {
            TweenLite.to(this._contArray[1],0.5,{
               "x":this._startPointArr[1].x,
               "y":this._startPointArr[1].y
            });
         }
      }
      
      private function completedHander3() : void
      {
         if(!this._isLeft)
         {
            if(this._contArray[0].x == this._pointArray[0].x)
            {
               TweenLite.to(this._contArray[2],0.5,{
                  "x":this._startPointArr[2].x,
                  "y":this._startPointArr[2].y
               });
            }
            else if(this._contArray[0].x == this._pointArray[2].x)
            {
               TweenLite.to(this._contArray[2],0.5,{
                  "x":this._startPointArr[1].x,
                  "y":this._startPointArr[1].y
               });
            }
            else if(this._contArray[0].x == this._pointArray[1].x)
            {
               TweenLite.to(this._contArray[2],0.5,{
                  "x":this._startPointArr[0].x,
                  "y":this._startPointArr[0].y
               });
            }
            return;
         }
         if(this._contArray[0].x == this._pointArray[0].x)
         {
            TweenLite.to(this._contArray[2],0.5,{
               "x":this._startPointArr[0].x,
               "y":this._startPointArr[0].y
            });
         }
         else if(this._contArray[0].x == this._pointArray[1].x)
         {
            TweenLite.to(this._contArray[2],0.5,{
               "x":this._startPointArr[1].x,
               "y":this._startPointArr[1].y
            });
         }
         else if(this._contArray[0].x == this._pointArray[2].x)
         {
            TweenLite.to(this._contArray[2],0.5,{
               "x":this._startPointArr[2].x,
               "y":this._startPointArr[2].y
            });
         }
      }
      
      public function dispose() : void
      {
         var tmp:GemstoneContent = null;
         removeEventListener(Event.ENTER_FRAME,this.enterframeHander);
         if(Boolean(this._lightning))
         {
            this._lightning.gotoAndStop(this._lightning.totalFrames);
         }
         ObjectUtils.disposeObject(this._lightning);
         this._lightning = null;
         if(Boolean(this._bombo))
         {
            this._bombo.gotoAndStop(this._bombo.totalFrames);
         }
         ObjectUtils.disposeObject(this._bombo);
         this._bombo = null;
         if(Boolean(this._groudMc))
         {
            this._groudMc.gotoAndStop(this._groudMc.totalFrames);
         }
         ObjectUtils.disposeObject(this._groudMc);
         this._groudMc = null;
         if(Boolean(this._upGradeMc))
         {
            this._upGradeMc.gotoAndStop(this._upGradeMc.totalFrames);
         }
         ObjectUtils.disposeObject(this._upGradeMc);
         this._upGradeMc = null;
         for each(tmp in this._contArray)
         {
            if(Boolean(tmp))
            {
               TweenLite.killTweensOf(tmp,true);
            }
            ObjectUtils.disposeObject(tmp);
         }
         this._contArray = null;
         this.staticDataList = null;
         this.curInfoList = null;
         this._info = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

