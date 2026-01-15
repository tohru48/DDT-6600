package ddt.manager
{
   import ddt.data.FightPropMode;
   import ddt.events.SharedEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.net.SharedObject;
   import flash.utils.Dictionary;
   
   [Event(name="change",type="flash.events.Event")]
   public class SharedManager extends EventDispatcher
   {
      
      public static var RIGHT_PROP:Array = [10001,10003,10002,10004,10005,10006,10007];
      
      public static const KEY_SET_ABLE:Array = [10001,10003,10002,10004,10005,10006,10007,10008];
      
      private static var instance:SharedManager = new SharedManager();
      
      public var allowMusic:Boolean = true;
      
      public var allowSound:Boolean = true;
      
      public var showTopMessageBar:Boolean = true;
      
      private var _showInvateWindow:Boolean = true;
      
      public var showParticle:Boolean = true;
      
      public var showOL:Boolean = true;
      
      public var showCI:Boolean = true;
      
      public var showHat:Boolean = true;
      
      public var showGlass:Boolean = true;
      
      public var showSuit:Boolean = true;
      
      public var fastReplys:Object = new Object();
      
      public var musicVolumn:int = 50;
      
      public var soundVolumn:int = 50;
      
      public var StrengthMoney:int = 1000;
      
      public var ComposeMoney:int = 1000;
      
      public var FusionMoney:int = 1000;
      
      public var TransferMoney:int = 1000;
      
      public var KeyAutoSnap:Boolean = true;
      
      public var ShowBattleGuide:Boolean = true;
      
      public var isHintPropExpire:Boolean = true;
      
      public var AutoReady:Boolean = true;
      
      public var GameKeySets:Object = new Object();
      
      public var AuctionInfos:Object = new Object();
      
      public var AuctionIDs:Object = new Object();
      
      public var setBagLocked:Boolean = false;
      
      public var hasStrength3:Object = new Object();
      
      public var recentContactsID:Object = new Object();
      
      public var StoreBuyInfo:Object = new Object();
      
      public var deadtip:int = 0;
      
      public var hasCheckedOverFrameRate:Boolean = false;
      
      public var hasEnteredFightLib:Object = new Object();
      
      public var isAffirm:Boolean = true;
      
      public var recommendNum:int = 0;
      
      public var isRecommend:Boolean = false;
      
      public var unAcceptAnswer:Array = [];
      
      public var isSetingMovieClip:Boolean = true;
      
      public var voteData:Dictionary = new Dictionary();
      
      public var giftFirstShow:Boolean = true;
      
      public var cardSystemShow:Boolean = true;
      
      public var texpSystemShow:Boolean = true;
      
      public var divorceBoolean:Boolean = true;
      
      public var friendBrithdayName:String = "";
      
      private var _autoSnsSend:Boolean = false;
      
      public var stoneFriend:Boolean = true;
      
      public var spacialReadedMail:Dictionary = new Dictionary();
      
      public var deleteMail:Dictionary = new Dictionary();
      
      public var privateChatRecord:Dictionary = new Dictionary();
      
      public var autoWish:Boolean = false;
      
      public var isRemindRoll:Boolean = false;
      
      public var isRemindRollBind:Boolean = false;
      
      public var isRemindOverCard:Boolean = false;
      
      public var isRemindOverCardBind:Boolean = false;
      
      public var transregionalblackList:Dictionary = new Dictionary();
      
      public var isAuctionHouseTodayUseBugle:Boolean = true;
      
      public var isRemindSnowPackDouble:Boolean = false;
      
      public var isRemindTreasureBind:Boolean = true;
      
      public var isTreasureBind:Boolean = false;
      
      public var lastBuyCount:int;
      
      public var isShowDdtImportantView:Boolean = true;
      
      private var _allowSnsSend:Boolean = false;
      
      private var _autoCelebration:Boolean = false;
      
      private var _autoCaddy:Boolean = false;
      
      private var _autoOfferPack:Boolean = false;
      
      private var _autoBead:Boolean = false;
      
      private var _autoWishBead:Boolean = false;
      
      private var _edictumVersion:String = "";
      
      private var _propLayerMode:int = 2;
      
      private var _isCommunity:Boolean = true;
      
      private var _isWishPop:Boolean;
      
      private var _isFirstWish:Boolean;
      
      public var isRefreshPet:Boolean = false;
      
      public var isRefreshSkill:Boolean = false;
      
      public var isRefreshBand:Boolean = false;
      
      public var isWorldBossBuyBuff:Boolean = false;
      
      public var isWorldBossBindBuyBuff:Boolean = false;
      
      public var isWorldBossBuyBuffFull:Boolean = false;
      
      public var isWorldBossBindBuyBuffFull:Boolean = false;
      
      public var isResurrect:Boolean = false;
      
      public var isResurrectBind:Boolean = true;
      
      public var isReFight:Boolean = false;
      
      public var isReFightBind:Boolean = true;
      
      public var awayAutoReply:Object = new Object();
      
      public var busyAutoReply:Object = new Object();
      
      public var noDistrubAutoReply:Object = new Object();
      
      public var shoppingAutoReply:Object = new Object();
      
      public var isDragonBoatOpenFrame:Boolean = false;
      
      public var flashInfoExist:Boolean;
      
      public var beadLeadTaskComplete:Boolean = false;
      
      public var beadLeadTaskSubmit:Boolean = false;
      
      public var beadLeadTaskStep:int = 0;
      
      public var halliconExperienceStep:int = 0;
      
      private var _autoVip:Boolean = false;
      
      private var _propTransparent:Boolean = false;
      
      public var boxType:int = 1;
      
      public var isBuyInteger:Boolean = false;
      
      public var isBuyIntegerBind:Boolean = true;
      
      public var isBuyHit:Boolean = false;
      
      public var isBuyHitBind:Boolean = true;
      
      public function SharedManager()
      {
         super();
      }
      
      public static function get Instance() : SharedManager
      {
         return instance;
      }
      
      public function get autoSnsSend() : Boolean
      {
         return this._autoSnsSend;
      }
      
      public function set autoSnsSend(value:Boolean) : void
      {
         if(this._autoSnsSend == value)
         {
            return;
         }
         this._autoSnsSend = value;
         this.save();
      }
      
      public function get allowSnsSend() : Boolean
      {
         return this._allowSnsSend;
      }
      
      public function get autoCelebration() : Boolean
      {
         return this._autoCelebration;
      }
      
      public function set autoCelebration(value:Boolean) : void
      {
         if(this._autoCelebration != value)
         {
            this._autoCelebration = value;
            this.save();
         }
      }
      
      public function get autoCaddy() : Boolean
      {
         return this._autoCaddy;
      }
      
      public function set autoCaddy(val:Boolean) : void
      {
         if(this._autoCaddy != val)
         {
            this._autoCaddy = val;
            this.save();
         }
      }
      
      public function get autoOfferPack() : Boolean
      {
         return this._autoOfferPack;
      }
      
      public function set autoOfferPack(val:Boolean) : void
      {
         if(this._autoOfferPack != val)
         {
            this._autoOfferPack = val;
            this.save();
         }
      }
      
      public function get autoBead() : Boolean
      {
         return this._autoBead;
      }
      
      public function set autoWishBead(val:Boolean) : void
      {
         if(this._autoWishBead != val)
         {
            this._autoWishBead = val;
            this.save();
         }
      }
      
      public function get autoWishBead() : Boolean
      {
         return this._autoWishBead;
      }
      
      public function set autoBead(val:Boolean) : void
      {
         if(this._autoBead != val)
         {
            this._autoBead = val;
            this.save();
         }
      }
      
      public function get edictumVersion() : String
      {
         return this._edictumVersion;
      }
      
      public function set edictumVersion(value:String) : void
      {
         if(this._edictumVersion != value)
         {
            this._edictumVersion = value;
            this.save();
         }
      }
      
      public function get propLayerMode() : int
      {
         if(PlayerManager.Instance.Self.Grade < 4)
         {
            return FightPropMode.VERTICAL;
         }
         return this._propLayerMode;
      }
      
      public function set propLayerMode(val:int) : void
      {
         if(this._propLayerMode != val)
         {
            this._propLayerMode = val;
            this.save();
         }
      }
      
      public function set allowSnsSend(value:Boolean) : void
      {
         if(this._allowSnsSend == value)
         {
            return;
         }
         this._allowSnsSend = value;
         this.save();
      }
      
      public function get showInvateWindow() : Boolean
      {
         return this._showInvateWindow;
      }
      
      public function set showInvateWindow(value:Boolean) : void
      {
         this._showInvateWindow = value;
      }
      
      public function get isCommunity() : Boolean
      {
         return this._isCommunity;
      }
      
      public function set isCommunity(value:Boolean) : void
      {
         this._isCommunity = value;
      }
      
      public function get isWishPop() : Boolean
      {
         return this._isWishPop;
      }
      
      public function set isWishPop(value:Boolean) : void
      {
         this._isWishPop = value;
      }
      
      public function get isFirstWish() : Boolean
      {
         return this._isFirstWish;
      }
      
      public function set isFirstWish(value:Boolean) : void
      {
         this._isFirstWish = value;
      }
      
      public function get autoVip() : Boolean
      {
         return this._autoVip;
      }
      
      public function set autoVip(val:Boolean) : void
      {
         if(this._autoVip != val)
         {
            this._autoVip = val;
            this.save();
         }
      }
      
      public function setup() : void
      {
         this.load();
      }
      
      public function reset() : void
      {
         var so:SharedObject = SharedObject.getLocal("road");
         so.clear();
         so.flush(20 * 1024 * 1024);
      }
      
      private function load() : void
      {
         var so:SharedObject = null;
         var key:String = null;
         var keyII:String = null;
         var keyIII:String = null;
         var keyIV:String = null;
         var keyV:String = null;
         var keyP:String = null;
         var keyT:String = null;
         var i:int = 0;
         var j:int = 0;
         var k:String = null;
         var id:String = null;
         var key1:String = null;
         var key2:String = null;
         var key3:String = null;
         var key4:String = null;
         var key5:String = null;
         var key6:String = null;
         var key7:String = null;
         try
         {
            so = SharedObject.getLocal("road");
            this.AuctionInfos = new Object();
            if(Boolean(so) && Boolean(so.data))
            {
               if(so.data["allowMusic"] != undefined)
               {
                  this.allowMusic = so.data["allowMusic"];
               }
               if(so.data["allowSound"] != undefined)
               {
                  this.allowSound = so.data["allowSound"];
               }
               if(so.data["showTopMessageBar"] != undefined)
               {
                  this.showTopMessageBar = so.data["showTopMessageBar"];
               }
               if(so.data["showInvateWindow"] != undefined)
               {
                  this.showInvateWindow = so.data["showInvateWindow"];
               }
               if(so.data["showParticle"] != undefined)
               {
                  this.showParticle = so.data["showParticle"];
               }
               if(so.data["showOL"] != undefined)
               {
                  this.showOL = so.data["showOL"];
               }
               if(so.data["showCI"] != undefined)
               {
                  this.showCI = so.data["showCI"];
               }
               if(so.data["showHat"] != undefined)
               {
                  this.showHat = so.data["showHat"];
               }
               if(so.data["showGlass"] != undefined)
               {
                  this.showGlass = so.data["showGlass"];
               }
               if(so.data["showSuit"] != undefined)
               {
                  this.showSuit = so.data["showSuit"];
               }
               if(so.data["musicVolumn"] != undefined)
               {
                  this.musicVolumn = so.data["musicVolumn"];
               }
               if(so.data["soundVolumn"] != undefined)
               {
                  this.soundVolumn = so.data["soundVolumn"];
               }
               if(so.data["KeyAutoSnap"] != undefined)
               {
                  this.KeyAutoSnap = so.data["KeyAutoSnap"];
               }
               if(so.data["giftFirstShow"] != undefined)
               {
                  this.giftFirstShow = so.data["giftFirstShow"];
               }
               if(so.data["cardSystemShow"] != undefined)
               {
                  this.cardSystemShow = so.data["cardSystemShow"];
               }
               if(so.data["texpSystemShow"] != undefined)
               {
                  this.texpSystemShow = so.data["texpSystemShow"];
               }
               if(so.data["divorceBoolean"] != undefined)
               {
                  this.divorceBoolean = so.data["divorceBoolean"];
               }
               if(so.data["friendBrithdayName"] != undefined)
               {
                  this.friendBrithdayName = so.data["friendBrithdayName"];
               }
               if(so.data["AutoReady"] != undefined)
               {
                  this.AutoReady = so.data["AutoReady"];
               }
               if(so.data["ShowBattleGuide"] != undefined)
               {
                  this.ShowBattleGuide = so.data["ShowBattleGuide"];
               }
               if(so.data["isHintPropExpire"] != undefined)
               {
                  this.isHintPropExpire = so.data["isHintPropExpire"];
               }
               if(so.data["hasCheckedOverFrameRate"] != undefined)
               {
                  this.hasCheckedOverFrameRate = so.data["hasCheckedOverFrameRate"];
               }
               if(so.data["isRecommend"] != undefined)
               {
                  this.isRecommend = so.data["isRecommend"];
               }
               if(so.data["recommendNum"] != undefined)
               {
                  this.recommendNum = so.data["recommendNum"];
               }
               if(so.data["isSetingMovieClip"] != undefined)
               {
                  this.isSetingMovieClip = so.data["isSetingMovieClip"];
               }
               if(so.data["propLayerMode"] != undefined)
               {
                  this._propLayerMode = so.data["propLayerMode"];
               }
               if(so.data["autoCaddy"] != undefined)
               {
                  this._autoCaddy = so.data["autoCaddy"];
               }
               if(so.data["autoOfferPack"] != undefined)
               {
                  this._autoOfferPack = so.data["autoOfferPack"];
               }
               if(so.data["autoBead"] != undefined)
               {
                  this._autoBead = so.data["autoBead"];
               }
               if(so.data["edictumVersion"] != undefined)
               {
                  this._edictumVersion = so.data["edictumVersion"];
               }
               if(so.data["isFirstWish"] != undefined)
               {
                  this._isFirstWish = so.data["isFirstWish"];
               }
               if(so.data["stoneFriend"] != undefined)
               {
                  this.stoneFriend = so.data["stoneFriend"];
               }
               if(so.data["autoCelebration"] != undefined)
               {
                  this._autoCelebration = so.data["autoCelebration"];
               }
               if(so.data["hasStrength3"] != undefined)
               {
                  for(key in so.data["hasStrength3"])
                  {
                     this.hasStrength3[key] = so.data["hasStrength3"][key];
                  }
               }
               if(so.data["recentContactsID"] != undefined)
               {
                  for(keyII in so.data["recentContactsID"])
                  {
                     this.recentContactsID[keyII] = so.data["recentContactsID"][keyII];
                  }
               }
               if(so.data["voteData"] != undefined)
               {
                  for(keyIII in so.data["voteData"])
                  {
                     this.voteData[keyIII] = so.data["voteData"][keyIII];
                  }
               }
               if(so.data["spacialReadedMail"] != undefined)
               {
                  for(keyIV in so.data["spacialReadedMail"])
                  {
                     this.spacialReadedMail[keyIV] = so.data["spacialReadedMail"][keyIV];
                  }
               }
               if(so.data["deleteMail"] != undefined)
               {
                  for(keyV in so.data["deleteMail"])
                  {
                     this.deleteMail[keyV] = so.data["deleteMail"][keyV];
                  }
               }
               if(so.data["privateChatRecord"] != undefined)
               {
                  for(keyP in so.data["privateChatRecord"])
                  {
                     this.privateChatRecord[keyP] = so.data["privateChatRecord"][keyP];
                  }
               }
               if(so.data["transregionalblackList"] != undefined)
               {
                  for(keyT in so.data["transregionalblackList"])
                  {
                     this.transregionalblackList[keyT] = so.data["transregionalblackList"][keyT];
                  }
               }
               if(so.data["GameKeySets"] != undefined)
               {
                  for(i = 1; i < KEY_SET_ABLE.length + 1; i++)
                  {
                     this.GameKeySets[String(i)] = so.data["GameKeySets"][String(i)];
                  }
               }
               else
               {
                  for(j = 0; j < KEY_SET_ABLE.length; j++)
                  {
                     this.GameKeySets[String(j + 1)] = KEY_SET_ABLE[j];
                  }
               }
               if(so.data["AuctionInfos"] != undefined)
               {
                  for(k in so.data["AuctionInfos"])
                  {
                     this.AuctionInfos[k] = so.data["AuctionInfos"][k];
                  }
               }
               if(so.data["AuctionIDs"] != undefined)
               {
                  this.AuctionIDs = so.data["AuctionIDs"];
                  for(id in so.data["AuctionInfos"])
                  {
                     this.AuctionIDs[id] = so.data["AuctionInfos"][id];
                  }
               }
               if(so.data["setBagLocked" + PlayerManager.Instance.Self.ID] != undefined)
               {
                  this.setBagLocked = so.data["setBagLocked"];
               }
               if(so.data["deadtip"] != undefined)
               {
                  this.deadtip = so.data["deadtip"];
               }
               if(so.data["StoreBuyInfo"] != undefined)
               {
                  for(key1 in so.data["StoreBuyInfo"])
                  {
                     this.StoreBuyInfo[key1] = so.data["StoreBuyInfo"][key1];
                  }
               }
               if(so.data["hasEnteredFightLib"] != undefined)
               {
                  for(key2 in so.data["hasEnteredFightLib"])
                  {
                     this.hasEnteredFightLib[key2] = so.data["hasEnteredFightLib"][key2];
                  }
               }
               if(so.data["isAffirm"] != this.isAffirm)
               {
                  this.isAffirm = so.data["isAffirm"];
               }
               if(so.data["fastReplys"] != undefined)
               {
                  for(key3 in so.data["fastReplys"])
                  {
                     this.fastReplys[key3] = so.data["fastReplys"][key3];
                  }
               }
               if(so.data["autoSnsSend"] != undefined)
               {
                  this._autoSnsSend = so.data["autoSnsSend"];
               }
               if(so.data["allowSnsSend"] != undefined)
               {
                  this._allowSnsSend = so.data["allowSnsSend"];
               }
               if(so.data["AwayAutoReply"] != undefined)
               {
                  for(key4 in so.data["AwayAutoReply"])
                  {
                     this.awayAutoReply[key4] = so.data["AwayAutoReply"][key4];
                  }
               }
               if(so.data["BusyAutoReply"] != undefined)
               {
                  for(key5 in so.data["BusyAutoReply"])
                  {
                     this.busyAutoReply[key5] = so.data["BusyAutoReply"][key5];
                  }
               }
               if(so.data["NoDistrubAutoReply"] != undefined)
               {
                  for(key6 in so.data["NoDistrubAutoReply"])
                  {
                     this.noDistrubAutoReply[key6] = so.data["NoDistrubAutoReply"][key6];
                  }
               }
               if(so.data["ShoppingAutoReply"] != undefined)
               {
                  for(key7 in so.data["ShoppingAutoReply"])
                  {
                     this.shoppingAutoReply[key7] = so.data["ShoppingAutoReply"][key7];
                  }
               }
               if(so.data["isCommunity"] != undefined)
               {
                  this.isCommunity = so.data["isCommunity"];
               }
               if(so.data["isWishPop"] != undefined)
               {
                  this.isWishPop = so.data["isWishPop"];
               }
               if(so.data["autoWish"] != undefined)
               {
                  this.autoWish = so.data["autoWish"];
               }
               if(so.data["isRefreshPet"] != undefined)
               {
                  this.isRefreshPet = so.data["isRefreshPet"];
               }
               if(so.data["isRefreshSkill"] != undefined)
               {
                  this.isRefreshSkill = so.data["isRefreshSkill"];
               }
               if(so.data["beadLeadTaskComplete"] != undefined)
               {
                  this.beadLeadTaskComplete = so.data["beadLeadTaskComplete"];
               }
               if(so.data["beadLeadTaskSubmit"] != undefined)
               {
                  this.beadLeadTaskSubmit = so.data["beadLeadTaskSubmit"];
               }
               if(so.data["beadLeadTaskStep"] != undefined)
               {
                  this.beadLeadTaskStep = so.data["beadLeadTaskStep"];
               }
               if(so.data["halliconExperienceStep"] != undefined)
               {
                  this.halliconExperienceStep = so.data["halliconExperienceStep"];
               }
               if(so.data["isWorldBossBuyBuff"] != undefined)
               {
                  this.isWorldBossBuyBuff = so.data["isWorldBossBuyBuff"];
               }
               if(so.data["isWorldBossBindBuyBuff"] != undefined)
               {
                  this.isWorldBossBindBuyBuff = so.data["isWorldBossBindBuyBuff"];
               }
               if(so.data["isWorldBossBuyBuffFull"] != undefined)
               {
                  this.isWorldBossBuyBuffFull = so.data["isWorldBossBuyBuffFull"];
               }
               if(so.data["isWorldBossBindBuyBuffFull"] != undefined)
               {
                  this.isWorldBossBindBuyBuffFull = so.data["isWorldBossBindBuyBuffFull"];
               }
               if(so.data["isResurrect"] != undefined)
               {
                  this.isResurrect = so.data["isResurrect"];
               }
               if(so.data["isReFight"] != undefined)
               {
                  this.isReFight = so.data["isReFight"];
               }
               if(so.data["isDragonBoatOpenFrame"] != undefined)
               {
                  this.isDragonBoatOpenFrame = so.data["isDragonBoatOpenFrame"];
               }
               if(so.data["isShowDdtImportantView"] != undefined)
               {
                  this.isShowDdtImportantView = so.data["isShowDdtImportantView"];
               }
               if(so.data["flashInfoExist"] != undefined)
               {
                  this.flashInfoExist = so.data["flashInfoExist"];
               }
            }
         }
         catch(e:Error)
         {
         }
         finally
         {
            this.changed();
         }
      }
      
      public function save() : void
      {
         var so:SharedObject = null;
         var obj:Object = null;
         var i:String = null;
         try
         {
            so = SharedObject.getLocal("road");
            so.data["allowMusic"] = this.allowMusic;
            so.data["allowSound"] = this.allowSound;
            so.data["showTopMessageBar"] = this.showTopMessageBar;
            so.data["showInvateWindow"] = this.showInvateWindow;
            so.data["showParticle"] = this.showParticle;
            so.data["showOL"] = this.showOL;
            so.data["showCI"] = this.showCI;
            so.data["showHat"] = this.showHat;
            so.data["showGlass"] = this.showGlass;
            so.data["showSuit"] = this.showSuit;
            so.data["musicVolumn"] = this.musicVolumn;
            so.data["soundVolumn"] = this.soundVolumn;
            so.data["KeyAutoSnap"] = this.KeyAutoSnap;
            so.data["giftFirstShow"] = this.giftFirstShow;
            so.data["cardSystemShow"] = this.cardSystemShow;
            so.data["texpSystemShow"] = this.texpSystemShow;
            so.data["divorceBoolean"] = this.divorceBoolean;
            so.data["friendBrithdayName"] = this.friendBrithdayName;
            so.data["AutoReady"] = this.AutoReady;
            so.data["ShowBattleGuide"] = this.ShowBattleGuide;
            so.data["isHintPropExpire"] = this.isHintPropExpire;
            so.data["hasCheckedOverFrameRate"] = this.hasCheckedOverFrameRate;
            so.data["isAffirm"] = this.isAffirm;
            so.data["isRecommend"] = this.isRecommend;
            so.data["recommendNum"] = this.recommendNum;
            so.data["isSetingMovieClip"] = this.isSetingMovieClip;
            so.data["propLayerMode"] = this.propLayerMode;
            so.data["autoCaddy"] = this._autoCaddy;
            so.data["autoOfferPack"] = this._autoOfferPack;
            so.data["autoBead"] = this._autoBead;
            so.data["edictumVersion"] = this._edictumVersion;
            so.data["stoneFriend"] = this.stoneFriend;
            so.data["autoCelebration"] = this._autoCelebration;
            obj = {};
            for(i in this.GameKeySets)
            {
               obj[i] = this.GameKeySets[i];
            }
            so.data["GameKeySets"] = obj;
            if(Boolean(this.AuctionInfos))
            {
               so.data["AuctionInfos"] = this.AuctionInfos;
            }
            if(Boolean(this.hasStrength3))
            {
               so.data["hasStrength3"] = this.hasStrength3;
            }
            if(Boolean(this.recentContactsID))
            {
               so.data["recentContactsID"] = this.recentContactsID;
            }
            if(Boolean(this.voteData))
            {
               so.data["voteData"] = this.voteData;
            }
            if(Boolean(this.spacialReadedMail))
            {
               so.data["spacialReadedMail"] = this.spacialReadedMail;
            }
            if(Boolean(this.deleteMail))
            {
               so.data["deleteMail"] = this.deleteMail;
            }
            if(Boolean(this.privateChatRecord))
            {
               so.data["privateChatRecord"] = this.privateChatRecord;
            }
            if(Boolean(this.transregionalblackList))
            {
               so.data["transregionalblackList"] = this.transregionalblackList;
            }
            if(Boolean(this.hasEnteredFightLib))
            {
               so.data["hasEnteredFightLib"] = this.hasEnteredFightLib;
            }
            if(Boolean(this.fastReplys))
            {
               so.data["fastReplys"] = this.fastReplys;
            }
            if(this.autoWish)
            {
               so.data["autoWish"] = this.autoWish;
            }
            so.data["isRefreshPet"] = this.isRefreshPet;
            so.data["isRefreshPet"] = this.isRefreshSkill;
            so.data["isWorldBossBuyBuff"] = this.isWorldBossBuyBuff;
            so.data["isWorldBossBindBuyBuff"] = this.isWorldBossBindBuyBuff;
            so.data["isWorldBossBuyBuffFull"] = this.isWorldBossBuyBuffFull;
            so.data["isWorldBossBindBuyBuffFull"] = this.isWorldBossBindBuyBuffFull;
            so.data["isResurrect"] = this.isResurrect;
            so.data["isWorldBossBuyBuff"] = this.isResurrect;
            so.data["isReFight"] = this.isReFight;
            so.data["AuctionIDs"] = this.AuctionIDs;
            so.data["setBagLocked"] = this.setBagLocked;
            so.data["deadtip"] = this.deadtip;
            so.data["StoreBuyInfo"] = this.StoreBuyInfo;
            so.data["autoSnsSend"] = this._autoSnsSend;
            so.data["allowSnsSend"] = this._allowSnsSend;
            so.data["AwayAutoReply"] = this.awayAutoReply;
            so.data["BusyAutoReply"] = this.busyAutoReply;
            so.data["NoDistrubAutoReply"] = this.noDistrubAutoReply;
            so.data["ShoppingAutoReply"] = this.shoppingAutoReply;
            so.data["isCommunity"] = this.isCommunity;
            so.data["isWishPop"] = this.isWishPop;
            so.data["isFirstWish"] = this.isFirstWish;
            so.data["isDragonBoatOpenFrame"] = this.isDragonBoatOpenFrame;
            so.data["beadLeadTaskComplete"] = this.beadLeadTaskComplete;
            so.data["beadLeadTaskSubmit"] = this.beadLeadTaskSubmit;
            so.data["beadLeadTaskStep"] = this.beadLeadTaskStep;
            so.data["halliconExperienceStep"] = this.halliconExperienceStep;
            so.data["isShowDdtImportantView"] = this.isShowDdtImportantView;
            so.data["flashInfoExist"] = this.flashInfoExist;
            so.flush(20 * 1024 * 1024);
         }
         catch(e:Error)
         {
         }
         this.changed();
      }
      
      public function changed() : void
      {
         var i:String = null;
         SoundManager.instance.setConfig(this.allowMusic,this.allowSound,this.musicVolumn,this.soundVolumn);
         for(i in this.GameKeySets)
         {
            if(Boolean(RIGHT_PROP[int(int(i) - 1)]))
            {
               RIGHT_PROP[int(int(i) - 1)] = this.GameKeySets[i];
            }
         }
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function set propTransparent(val:Boolean) : void
      {
         if(this._propTransparent != val)
         {
            this._propTransparent = val;
            dispatchEvent(new SharedEvent(SharedEvent.TRANSPARENTCHANGED));
         }
      }
      
      public function get propTransparent() : Boolean
      {
         return this._propTransparent;
      }
   }
}

