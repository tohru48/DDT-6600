// Decompiled with JetBrains decompiler
// Type: Game.Logic.Phy.Object.Player
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Bussiness;
using Game.Logic.Actions;
using Game.Logic.Effects;
using Game.Logic.HorseEffects;
using Game.Logic.PetEffects;
using Game.Logic.Phy.Maths;
using Game.Logic.Spells;
using SqlDataProvider.Data;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Drawing;
using System.Threading;

#nullable disable
namespace Game.Logic.Phy.Object
{
  public class Player : TurnedLiving
  {
    private IGamePlayer igamePlayer_0;
    private UsersPetinfo usersPetinfo_0;
    private SqlDataProvider.Data.ItemInfo itemInfo_0;
    private SqlDataProvider.Data.ItemInfo itemInfo_1;
    private SqlDataProvider.Data.ItemInfo itemInfo_2;
    private int int_10;
    private int int_11;
    private int int_12;
    private int int_13;
    private PetFightPropertyInfo petFightPropertyInfo_0;
    private BallInfo ballInfo_0;
    private int int_14;
    private bool bool_9;
    private int int_15;
    public Point TargetPoint;
    public int GainGP;
    public int GainOffer;
    public bool LockDirection;
    public int TotalCure;
    private bool bool_10;
    public int TotalAllHurt;
    public int TotalAllHitTargetCount;
    public int TotalAllShootCount;
    public int TotalAllKill;
    public int TotalAllExperience;
    public int TotalAllScore;
    public int TotalAllCure;
    public int CanTakeOut;
    public bool FinishTakeCard;
    public bool HasPaymentTakeCard;
    public int BossCardCount;
    public bool Ready;
    public int TotalCureEnergy;
    public bool LimitEnergy;
    private Dictionary<int, PetSkillInfo> dictionary_0;
    private Dictionary<int, MountSkillTemplateInfo> dictionary_1;
    private int[] int_16;
    private BatleConfigInfo batleConfigInfo_0;
    private int int_17;
    private int int_18;
    private int int_19;
    private int int_20;
    private ArrayList arrayList_0;
    private int int_21;
    private static readonly int int_22 = 10016;
    private int int_23;
    private PlayerEventHandle playerEventHandle_0;
    private PlayerEventHandle playerEventHandle_1;
    private PlayerEventHandle playerEventHandle_2;
    private PlayerEventHandle playerEventHandle_3;
    private PlayerEventHandle playerEventHandle_4;
    private PlayerEventHandle playerEventHandle_5;
    private PlayerEventHandle playerEventHandle_6;
    private PlayerEventHandle playerEventHandle_7;
    private PlayerEventHandle playerEventHandle_8;
    private PlayerEventHandle playerEventHandle_9;
    private PlayerEventHandle playerEventHandle_10;

    public event PlayerEventHandle PlayerBeginMoving
    {
      add
      {
        PlayerEventHandle playerEventHandle = this.playerEventHandle_0;
        PlayerEventHandle comparand;
        do
        {
          comparand = playerEventHandle;
          playerEventHandle = Interlocked.CompareExchange<PlayerEventHandle>(ref this.playerEventHandle_0, comparand + value, comparand);
        }
        while (playerEventHandle != comparand);
      }
      remove
      {
        PlayerEventHandle playerEventHandle = this.playerEventHandle_0;
        PlayerEventHandle comparand;
        do
        {
          comparand = playerEventHandle;
          playerEventHandle = Interlocked.CompareExchange<PlayerEventHandle>(ref this.playerEventHandle_0, comparand - value, comparand);
        }
        while (playerEventHandle != comparand);
      }
    }

    public event PlayerEventHandle AfterPlayerShooted
    {
      add
      {
        PlayerEventHandle playerEventHandle = this.playerEventHandle_1;
        PlayerEventHandle comparand;
        do
        {
          comparand = playerEventHandle;
          playerEventHandle = Interlocked.CompareExchange<PlayerEventHandle>(ref this.playerEventHandle_1, comparand + value, comparand);
        }
        while (playerEventHandle != comparand);
      }
      remove
      {
        PlayerEventHandle playerEventHandle = this.playerEventHandle_1;
        PlayerEventHandle comparand;
        do
        {
          comparand = playerEventHandle;
          playerEventHandle = Interlocked.CompareExchange<PlayerEventHandle>(ref this.playerEventHandle_1, comparand - value, comparand);
        }
        while (playerEventHandle != comparand);
      }
    }

    public event PlayerEventHandle BeforePlayerShoot
    {
      add
      {
        PlayerEventHandle playerEventHandle = this.playerEventHandle_2;
        PlayerEventHandle comparand;
        do
        {
          comparand = playerEventHandle;
          playerEventHandle = Interlocked.CompareExchange<PlayerEventHandle>(ref this.playerEventHandle_2, comparand + value, comparand);
        }
        while (playerEventHandle != comparand);
      }
      remove
      {
        PlayerEventHandle playerEventHandle = this.playerEventHandle_2;
        PlayerEventHandle comparand;
        do
        {
          comparand = playerEventHandle;
          playerEventHandle = Interlocked.CompareExchange<PlayerEventHandle>(ref this.playerEventHandle_2, comparand - value, comparand);
        }
        while (playerEventHandle != comparand);
      }
    }

    public event PlayerEventHandle LoadingCompleted
    {
      add
      {
        PlayerEventHandle playerEventHandle = this.playerEventHandle_3;
        PlayerEventHandle comparand;
        do
        {
          comparand = playerEventHandle;
          playerEventHandle = Interlocked.CompareExchange<PlayerEventHandle>(ref this.playerEventHandle_3, comparand + value, comparand);
        }
        while (playerEventHandle != comparand);
      }
      remove
      {
        PlayerEventHandle playerEventHandle = this.playerEventHandle_3;
        PlayerEventHandle comparand;
        do
        {
          comparand = playerEventHandle;
          playerEventHandle = Interlocked.CompareExchange<PlayerEventHandle>(ref this.playerEventHandle_3, comparand - value, comparand);
        }
        while (playerEventHandle != comparand);
      }
    }

    public event PlayerEventHandle PlayerShoot
    {
      add
      {
        PlayerEventHandle playerEventHandle = this.playerEventHandle_4;
        PlayerEventHandle comparand;
        do
        {
          comparand = playerEventHandle;
          playerEventHandle = Interlocked.CompareExchange<PlayerEventHandle>(ref this.playerEventHandle_4, comparand + value, comparand);
        }
        while (playerEventHandle != comparand);
      }
      remove
      {
        PlayerEventHandle playerEventHandle = this.playerEventHandle_4;
        PlayerEventHandle comparand;
        do
        {
          comparand = playerEventHandle;
          playerEventHandle = Interlocked.CompareExchange<PlayerEventHandle>(ref this.playerEventHandle_4, comparand - value, comparand);
        }
        while (playerEventHandle != comparand);
      }
    }

    public event PlayerEventHandle PlayerCure
    {
      add
      {
        PlayerEventHandle playerEventHandle = this.playerEventHandle_5;
        PlayerEventHandle comparand;
        do
        {
          comparand = playerEventHandle;
          playerEventHandle = Interlocked.CompareExchange<PlayerEventHandle>(ref this.playerEventHandle_5, comparand + value, comparand);
        }
        while (playerEventHandle != comparand);
      }
      remove
      {
        PlayerEventHandle playerEventHandle = this.playerEventHandle_5;
        PlayerEventHandle comparand;
        do
        {
          comparand = playerEventHandle;
          playerEventHandle = Interlocked.CompareExchange<PlayerEventHandle>(ref this.playerEventHandle_5, comparand - value, comparand);
        }
        while (playerEventHandle != comparand);
      }
    }

    public event PlayerEventHandle PlayerGuard
    {
      add
      {
        PlayerEventHandle playerEventHandle = this.playerEventHandle_6;
        PlayerEventHandle comparand;
        do
        {
          comparand = playerEventHandle;
          playerEventHandle = Interlocked.CompareExchange<PlayerEventHandle>(ref this.playerEventHandle_6, comparand + value, comparand);
        }
        while (playerEventHandle != comparand);
      }
      remove
      {
        PlayerEventHandle playerEventHandle = this.playerEventHandle_6;
        PlayerEventHandle comparand;
        do
        {
          comparand = playerEventHandle;
          playerEventHandle = Interlocked.CompareExchange<PlayerEventHandle>(ref this.playerEventHandle_6, comparand - value, comparand);
        }
        while (playerEventHandle != comparand);
      }
    }

    public event PlayerEventHandle PlayerBuffSkillPet
    {
      add
      {
        PlayerEventHandle playerEventHandle = this.playerEventHandle_7;
        PlayerEventHandle comparand;
        do
        {
          comparand = playerEventHandle;
          playerEventHandle = Interlocked.CompareExchange<PlayerEventHandle>(ref this.playerEventHandle_7, comparand + value, comparand);
        }
        while (playerEventHandle != comparand);
      }
      remove
      {
        PlayerEventHandle playerEventHandle = this.playerEventHandle_7;
        PlayerEventHandle comparand;
        do
        {
          comparand = playerEventHandle;
          playerEventHandle = Interlocked.CompareExchange<PlayerEventHandle>(ref this.playerEventHandle_7, comparand - value, comparand);
        }
        while (playerEventHandle != comparand);
      }
    }

    public event PlayerEventHandle PlayerBuffSkillHorse
    {
      add
      {
        PlayerEventHandle playerEventHandle = this.playerEventHandle_8;
        PlayerEventHandle comparand;
        do
        {
          comparand = playerEventHandle;
          playerEventHandle = Interlocked.CompareExchange<PlayerEventHandle>(ref this.playerEventHandle_8, comparand + value, comparand);
        }
        while (playerEventHandle != comparand);
      }
      remove
      {
        PlayerEventHandle playerEventHandle = this.playerEventHandle_8;
        PlayerEventHandle comparand;
        do
        {
          comparand = playerEventHandle;
          playerEventHandle = Interlocked.CompareExchange<PlayerEventHandle>(ref this.playerEventHandle_8, comparand - value, comparand);
        }
        while (playerEventHandle != comparand);
      }
    }

    public event PlayerEventHandle CollidByObject
    {
      add
      {
        PlayerEventHandle playerEventHandle = this.playerEventHandle_9;
        PlayerEventHandle comparand;
        do
        {
          comparand = playerEventHandle;
          playerEventHandle = Interlocked.CompareExchange<PlayerEventHandle>(ref this.playerEventHandle_9, comparand + value, comparand);
        }
        while (playerEventHandle != comparand);
      }
      remove
      {
        PlayerEventHandle playerEventHandle = this.playerEventHandle_9;
        PlayerEventHandle comparand;
        do
        {
          comparand = playerEventHandle;
          playerEventHandle = Interlocked.CompareExchange<PlayerEventHandle>(ref this.playerEventHandle_9, comparand - value, comparand);
        }
        while (playerEventHandle != comparand);
      }
    }

    public event PlayerEventHandle PlayerUseDander
    {
      add
      {
        PlayerEventHandle playerEventHandle = this.playerEventHandle_10;
        PlayerEventHandle comparand;
        do
        {
          comparand = playerEventHandle;
          playerEventHandle = Interlocked.CompareExchange<PlayerEventHandle>(ref this.playerEventHandle_10, comparand + value, comparand);
        }
        while (playerEventHandle != comparand);
      }
      remove
      {
        PlayerEventHandle playerEventHandle = this.playerEventHandle_10;
        PlayerEventHandle comparand;
        do
        {
          comparand = playerEventHandle;
          playerEventHandle = Interlocked.CompareExchange<PlayerEventHandle>(ref this.playerEventHandle_10, comparand - value, comparand);
        }
        while (playerEventHandle != comparand);
      }
    }

    public Dictionary<int, PetSkillInfo> PetSkillCD => this.dictionary_0;

    public Dictionary<int, MountSkillTemplateInfo> HorseSkillCD => this.dictionary_1;

    public int[] HorseSkillEquip => this.int_16;

    public BatleConfigInfo BatleConfig => this.batleConfigInfo_0;

    public IGamePlayer PlayerDetail => this.igamePlayer_0;

    public UsersPetinfo Pet => this.usersPetinfo_0;

    public SqlDataProvider.Data.ItemInfo Weapon => this.itemInfo_0;

    public SqlDataProvider.Data.ItemInfo DeputyWeapon => this.itemInfo_1;

    public bool IsActive => this.bool_9;

    public int Prop
    {
      get => this.int_15;
      set => this.int_15 = value;
    }

    public bool CanGetProp
    {
      get => this.bool_10;
      set
      {
        if (this.bool_10 == value)
          return;
        this.bool_10 = value;
      }
    }

    public int LoadingProcess
    {
      get => this.int_17;
      set
      {
        if (this.int_17 == value)
          return;
        this.int_17 = value;
        if (this.int_17 >= 100)
          this.OnLoadingCompleted();
      }
    }

    public int Energy
    {
      get => this.int_14;
      set => this.int_14 = value;
    }

    public BallInfo CurrentBall => this.ballInfo_0;

    public bool IsSpecialSkill => this.ballInfo_0.ID == this.int_11;

    public int ChangeSpecialBall
    {
      get => this.int_20;
      set => this.int_20 = value;
    }

    public int ShootCount
    {
      get => this.int_18;
      set
      {
        if (this.int_18 == value)
          return;
        this.int_18 = value;
        this.m_game.method_38(this);
      }
    }

    public int BallCount
    {
      get => this.int_19;
      set
      {
        if (this.int_19 == value)
          return;
        this.int_19 = value;
      }
    }

    public int deputyWeaponCount => this.int_21;

    public int flyCount => this.int_23;

    public Player(IGamePlayer player, int id, BaseGame game, int team, int maxBlood)
      : base(id, game, team, "", "", maxBlood, 0, 1)
    {
      this.arrayList_0 = new ArrayList();
      this.int_23 = 2;
      this.m_rect = new Rectangle(-15, -20, 30, 30);
      this.dictionary_0 = new Dictionary<int, PetSkillInfo>();
      this.dictionary_1 = new Dictionary<int, MountSkillTemplateInfo>();
      this.igamePlayer_0 = player;
      this.igamePlayer_0.GamePlayerId = id;
      this.bool_9 = true;
      this.bool_10 = true;
      this.Grade = player.PlayerCharacter.Grade;
      this.VaneOpen = player.PlayerCharacter.IsWeakGuildFinish(9);
      this.usersPetinfo_0 = player.Pet;
      this.batleConfigInfo_0 = this.igamePlayer_0.BatleConfig;
      this.int_16 = player.HorseSkillEquip;
      if (this.usersPetinfo_0 != null && game != null && game.RoomType != eRoomType.FightFootballTime)
      {
        this.isPet = true;
        this.PetEffects.PetBaseAtt = this.GetPetBaseAtt();
        this.InitPetSkillEffect();
        this.petFightPropertyInfo_0 = PetMgr.FindFightProperty(player.PlayerCharacter.evolutionGrade);
      }
      this.InitHourseSkillEffect();
      this.InitFightBuffer(player.FightBuffs);
      this.TotalAllHurt = 0;
      this.TotalAllHitTargetCount = 0;
      this.TotalAllShootCount = 0;
      this.TotalAllKill = 0;
      this.TotalAllExperience = 0;
      this.TotalAllScore = 0;
      this.TotalAllCure = 0;
      this.itemInfo_1 = this.igamePlayer_0.SecondWeapon;
      this.itemInfo_2 = this.igamePlayer_0.Healstone;
      this.ChangeSpecialBall = 0;
      this.int_21 = this.itemInfo_1 == null ? 1 : this.itemInfo_1.StrengthenLevel + 1;
      this.itemInfo_0 = this.igamePlayer_0.MainWeapon;
      if (this.itemInfo_0 != null)
      {
        BallConfigInfo ball = BallConfigMgr.FindBall(this.itemInfo_0.TemplateID);
        if (this.itemInfo_0.IsGold)
          ball = BallConfigMgr.FindBall(this.itemInfo_0.GoldEquip.TemplateID);
        this.int_10 = ball.Common;
        this.int_11 = ball.Special;
        this.int_12 = ball.CommonAddWound;
        this.int_13 = ball.CommonMultiBall;
      }
      this.int_17 = 0;
      this.int_15 = 0;
      this.InitEqupedEffect(this.igamePlayer_0.EquipEffect);
      this.int_14 = (this.igamePlayer_0.PlayerCharacter.AgiAddPlus + this.igamePlayer_0.PlayerCharacter.Agility) / 30 + 240;
      this.m_maxBlood = this.igamePlayer_0.PlayerCharacter.hp;
      if (this.FightBuffers.ConsortionAddMaxBlood > 0)
        this.m_maxBlood += this.m_maxBlood * this.FightBuffers.ConsortionAddMaxBlood / 100;
      this.m_maxBlood += this.igamePlayer_0.PlayerCharacter.HpAddPlus + this.FightBuffers.WorldBossHP + this.FightBuffers.WorldBossHP_MoneyBuff + this.PetEffects.MaxBlood;
    }

    public int GetPetBaseAtt()
    {
      try
      {
        string skillEquip = this.usersPetinfo_0.SkillEquip;
        char[] chArray1 = new char[1]{ '|' };
        foreach (string str in skillEquip.Split(chArray1))
        {
          char[] chArray2 = new char[1]{ ',' };
          PetSkillInfo petSkill = PetMgr.FindPetSkill(Convert.ToInt32(str.Split(chArray2)[0]));
          if (petSkill != null && petSkill.Damage > 0)
            return petSkill.Damage;
        }
      }
      catch (Exception ex)
      {
        Console.WriteLine("______________GetPetBaseAtt ERROR______________");
        Console.WriteLine(ex.Message);
        Console.WriteLine(ex.StackTrace);
        Console.WriteLine("_______________________________________________");
        return 0;
      }
      return 0;
    }

    public override void Reset()
    {
      if (this.m_game.RoomType != eRoomType.Dungeon && this.m_game.RoomType != eRoomType.SpecialActivityDungeon)
        this.m_game.Cards = new int[9];
      else
        this.m_game.Cards = new int[21];
      this.Dander = 0;
      this.PetMP = 10;
      this.psychic = 40;
      this.IsLiving = true;
      this.FinishTakeCard = false;
      this.itemInfo_2 = this.igamePlayer_0.Healstone;
      this.int_20 = 0;
      this.itemInfo_1 = this.igamePlayer_0.SecondWeapon;
      this.itemInfo_0 = this.igamePlayer_0.MainWeapon;
      BallConfigInfo ball = BallConfigMgr.FindBall(this.itemInfo_0.TemplateID);
      this.int_10 = ball.Common;
      this.int_11 = ball.Special;
      this.int_12 = ball.CommonAddWound;
      this.int_13 = ball.CommonMultiBall;
      this.BaseDamage = this.igamePlayer_0.BaseAttack;
      this.BaseGuard = this.igamePlayer_0.BaseDefence;
      this.Attack = (double) this.igamePlayer_0.PlayerCharacter.Attack;
      this.Defence = (double) this.igamePlayer_0.PlayerCharacter.Defence;
      this.Agility = (double) this.igamePlayer_0.PlayerCharacter.Agility;
      this.Lucky = (double) this.igamePlayer_0.PlayerCharacter.Luck;
      this.MagicAttack = (double) this.igamePlayer_0.PlayerCharacter.MagicAttack;
      this.MagicDefence = (double) this.igamePlayer_0.PlayerCharacter.MagicDefence;
      this.m_maxBlood = this.igamePlayer_0.PlayerCharacter.hp;
      this.BaseDamage += (double) (this.igamePlayer_0.PlayerCharacter.DameAddPlus + this.FightBuffers.WorldBossAttrack_MoneyBuff);
      if (this.FightBuffers.ConsortionAddDamage > 0)
        this.BaseDamage += (double) this.FightBuffers.ConsortionAddDamage;
      this.BaseGuard += (double) (this.igamePlayer_0.PlayerCharacter.GuardAddPlus + this.PetEffects.BonusGuard);
      this.Attack += (double) (this.igamePlayer_0.PlayerCharacter.AttackAddPlus + this.PetEffects.BonusAttack);
      this.Defence += (double) (this.igamePlayer_0.PlayerCharacter.DefendAddPlus + this.PetEffects.BonusDefend);
      this.Agility += (double) (this.igamePlayer_0.PlayerCharacter.AgiAddPlus + this.PetEffects.BonusAgility);
      this.Lucky += (double) (this.igamePlayer_0.PlayerCharacter.LuckAddPlus + this.PetEffects.BonusLucky);
      this.m_maxBlood = this.igamePlayer_0.PlayerCharacter.hp;
      if (this.petFightPropertyInfo_0 != null)
      {
        this.Attack += (double) this.petFightPropertyInfo_0.Attack;
        this.Defence += (double) this.petFightPropertyInfo_0.Defence;
        this.Agility += (double) this.petFightPropertyInfo_0.Agility;
        this.Lucky += (double) this.petFightPropertyInfo_0.Lucky;
        this.m_maxBlood += this.petFightPropertyInfo_0.Blood;
      }
      this.Attack += (double) this.igamePlayer_0.PlayerCharacter.StrengthEnchance;
      this.Defence += (double) this.igamePlayer_0.PlayerCharacter.StrengthEnchance;
      this.Agility += (double) this.igamePlayer_0.PlayerCharacter.StrengthEnchance;
      this.Lucky += (double) this.igamePlayer_0.PlayerCharacter.StrengthEnchance;
      if (this.FightBuffers.ConsortionAddMaxBlood > 0)
        this.m_maxBlood += this.m_maxBlood * this.FightBuffers.ConsortionAddMaxBlood / 100;
      this.m_maxBlood += this.igamePlayer_0.PlayerCharacter.HpAddPlus + this.FightBuffers.WorldBossHP + this.FightBuffers.WorldBossHP_MoneyBuff + this.PetEffects.MaxBlood;
      if (this.FightBuffers.ConsortionAddProperty > 0)
      {
        this.Attack += (double) this.FightBuffers.ConsortionAddProperty;
        this.Defence += (double) this.FightBuffers.ConsortionAddProperty;
        this.Agility += (double) this.FightBuffers.ConsortionAddProperty;
        this.Lucky += (double) this.FightBuffers.ConsortionAddProperty;
      }
      this.int_14 = (int) this.Agility / 30 + 240;
      if (this.FightBuffers.ConsortionAddEnergy > 0)
        this.int_14 += this.FightBuffers.ConsortionAddEnergy;
      this.ballInfo_0 = BallMgr.FindBall(this.int_10);
      this.int_18 = 1;
      this.int_19 = 1;
      this.int_15 = 0;
      this.CurrentIsHitTarget = false;
      this.LimitEnergy = false;
      this.TotalCure = 0;
      this.TotalHitTargetCount = 0;
      this.TotalHurt = 0;
      this.TotalKill = 0;
      this.TotalShootCount = 0;
      this.LockDirection = false;
      this.GainGP = 0;
      this.GainOffer = 0;
      this.Ready = false;
      this.PlayerDetail.ClearTempBag();
      this.m_delay = this.method_0();
      this.LoadingProcess = 0;
      this.ResetSkillCd();
      base.Reset();
    }

    public void ResetSkillCd()
    {
      if (this.usersPetinfo_0 != null)
      {
        string skillEquip = this.usersPetinfo_0.SkillEquip;
        char[] chArray1 = new char[1]{ '|' };
        foreach (string str in skillEquip.Split(chArray1))
        {
          char[] chArray2 = new char[1]{ ',' };
          int key = int.Parse(str.Split(chArray2)[0]);
          if (this.dictionary_0.ContainsKey(key))
            this.dictionary_0[key].Turn = this.dictionary_0[key].ColdDown;
        }
      }
      foreach (int key in this.HorseSkillEquip)
      {
        if (this.dictionary_1.ContainsKey(key))
        {
          this.dictionary_1[key].Turn = 0;
          this.dictionary_1[key].Count = 0;
        }
      }
    }

    public void InitHourseSkillEffect()
    {
      foreach (int num in this.HorseSkillEquip)
      {
        MountSkillTemplateInfo mountSkillTemplate = MountMgr.GetMountSkillTemplate(num);
        if (mountSkillTemplate != null && !this.dictionary_1.ContainsKey(num))
          this.dictionary_1.Add(num, mountSkillTemplate);
        if (mountSkillTemplate != null)
        {
          string[] strArray = mountSkillTemplate.String_0.Split(',');
          int coldDown = mountSkillTemplate.ColdDown;
          int probability = mountSkillTemplate.Probability;
          int delay = mountSkillTemplate.Delay;
          int gameType = mountSkillTemplate.GameType;
          foreach (string elementID in strArray)
          {
            string str;
            switch (str = elementID)
            {
              case "10101":
              case "10102":
              case "10103":
              case "10104":
              case "10105":
              case "10106":
              case "10107":
              case "10108":
              case "10109":
              case "10110":
                new HorseBuffHPEquipEffect(0, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "10201":
              case "10202":
              case "10203":
              case "10204":
              case "10205":
              case "10206":
              case "10207":
              case "10208":
              case "10209":
              case "10210":
                new HorseBuffHPTeamEquipEffect(0, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "10401":
              case "10402":
              case "10403":
              case "10404":
              case "10405":
                new HorseBuffDanderEquipEffect(0, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "11401":
              case "11402":
              case "11403":
              case "11404":
              case "11405":
                new HorseAddDamageNextDanderEquipEffect(0, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "10301":
              case "10302":
              case "10303":
              case "10304":
              case "10305":
              case "10306":
              case "10307":
              case "10308":
              case "10309":
              case "10310":
                new HorseRemoveGuardEnemyEquipEffect(0, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "10501":
              case "10502":
              case "10503":
              case "10504":
              case "10505":
                new HorseReviveTeamEquipEffect(0, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "10601":
              case "10602":
              case "10603":
              case "10604":
              case "10605":
              case "10606":
              case "10607":
              case "10608":
              case "10609":
              case "10610":
                new HorseRemoveRandomEffectEquipEffect(0, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "10701":
              case "10702":
              case "10703":
              case "10704":
              case "10705":
                new HorseFrostEquipEffect(0, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "10801":
              case "10802":
              case "10803":
              case "10804":
              case "10805":
                new HorseControlBallEquipEffect(0, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "10901":
              case "10902":
              case "10903":
              case "10904":
              case "10905":
                new HorseHideEquipEffect(3, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "11001":
              case "11002":
              case "11003":
              case "11004":
              case "11005":
                new HorseHideEquipEffect(2, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "11101":
              case "11102":
              case "11103":
              case "11104":
              case "11105":
              case "11106":
              case "11107":
              case "11108":
              case "11109":
              case "11110":
                new HorseAddDamageEquipEffect(2, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "11201":
              case "11202":
              case "11203":
              case "11204":
              case "11205":
                new HorseNoHoleEquipEffect(1, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "11301":
              case "11302":
              case "11303":
              case "11304":
              case "11305":
              case "11306":
              case "11307":
              case "11308":
              case "11309":
              case "11310":
                new HorseReduceDamageEquipEffect(2, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
            }
          }
        }
      }
    }

    public void InitFightBuffer(List<BufferInfo> buffers)
    {
      foreach (BufferInfo buffer in buffers)
      {
        switch (buffer.Type)
        {
          case 101:
            this.FightBuffers.ConsortionAddBloodGunCount = buffer.Value;
            break;
          case 102:
            this.FightBuffers.ConsortionAddDamage = buffer.Value;
            break;
          case 103:
            this.FightBuffers.ConsortionAddCritical = buffer.Value;
            break;
          case 104:
            this.FightBuffers.ConsortionAddMaxBlood = buffer.Value;
            break;
          case 105:
            this.FightBuffers.ConsortionAddProperty = buffer.Value;
            break;
          case 106:
            this.FightBuffers.ConsortionReduceEnergyUse = buffer.Value;
            break;
          case 107:
            this.FightBuffers.ConsortionAddEnergy = buffer.Value;
            break;
          case 108:
            this.FightBuffers.ConsortionAddEffectTurn = buffer.Value;
            break;
          case 109:
            this.FightBuffers.ConsortionAddOfferRate = buffer.Value;
            break;
          case 110:
            this.FightBuffers.ConsortionAddPercentGoldOrGP = buffer.Value;
            break;
          case 111:
            this.FightBuffers.ConsortionAddSpellCount = buffer.Value;
            break;
          case 112:
            this.FightBuffers.ConsortionReduceDander = buffer.Value;
            break;
          case 400:
            this.FightBuffers.WorldBossHP = buffer.Value;
            break;
          case 401:
            this.FightBuffers.WorldBossAttrack = buffer.Value;
            break;
          case 402:
            this.FightBuffers.WorldBossHP_MoneyBuff = buffer.Value;
            break;
          case 403:
            this.FightBuffers.WorldBossAttrack_MoneyBuff = buffer.Value;
            break;
          case 404:
            this.FightBuffers.WorldBossMetalSlug = buffer.Value;
            break;
          case 405:
            this.FightBuffers.WorldBossAncientBlessings = buffer.Value;
            break;
          case 406:
            this.FightBuffers.WorldBossAddDamage = buffer.Value;
            break;
          default:
            Console.WriteLine(string.Format("Not Found FightBuff Type {0} Value {1}", (object) buffer.Type, (object) buffer.Value));
            break;
        }
      }
    }

    public void InitPetSkillEffect()
    {
      string skillEquip = this.usersPetinfo_0.SkillEquip;
      char[] chArray1 = new char[1]{ '|' };
      foreach (string str1 in skillEquip.Split(chArray1))
      {
        char[] chArray2 = new char[1]{ ',' };
        int num = int.Parse(str1.Split(chArray2)[0]);
        PetSkillInfo petSkill = PetMgr.FindPetSkill(num);
        if (petSkill != null)
        {
          string[] strArray = petSkill.String_0.Split(',');
          int coldDown = petSkill.ColdDown;
          int probability = petSkill.Probability;
          int delay = petSkill.Delay;
          int gameType = petSkill.GameType;
          if (!this.dictionary_0.ContainsKey(num))
            this.dictionary_0.Add(num, petSkill);
          foreach (string elementID in strArray)
          {
            string str2;
            switch (str2 = elementID)
            {
              case "1017":
                new PetStopMovingEquipEffect(2, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1018":
              case "1019":
              case "1020":
              case "1046":
              case "1047":
              case "1048":
                new PetAddDefendEquipEffect(2, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1021":
                new PetNoHoleEquipEffect(2, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1132":
                new PetReduceAttackEquipEffect(2, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1038":
                new PetFatalEffect(0, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1070":
                new PetRemovePlusDameEquipEffect(0, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1072":
              case "1073":
                new PetPlusDameEquipEffect(0, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1049":
              case "1050":
                new PetPlusGuardEquipEffect(0, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1120":
              case "1121":
              case "1241":
              case "1242":
                new PetAddGuardEquipEffect(0, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1055":
                new PetClearPlusGuardEquipEffect(0, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1106":
                new PetPlusOneMpEquipEffect(0, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1076":
              case "1077":
                new PetAttackAroundEquipEffect(0, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1082":
                new PetAlwayNoHoleEquipEffect(0, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1083":
              case "1084":
                new PetAddAttackEquipEffect(0, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1085":
              case "1086":
                new PetAddLuckAllMatchEquipEffect(0, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1087":
              case "1088":
                new PetReduceDefendEquipEffect(0, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1089":
                new PetClearV3BatteryEquipEffect(0, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1200":
                new PetPlusAllTwoMpEquipEffect(0, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1223":
              case "1253":
              case "1263":
                new PetPlusTwoMpEquipEffect(0, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1135":
              case "1231":
              case "1246":
              case "1247":
                new PetReduceTakeDamageEquipEffect(0, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1029":
              case "1030":
              case "1031":
              case "1032":
              case "1033":
              case "1034":
              case "1232":
              case "1233":
              case "1234":
                new PetReduceDamageEquipEffect(1, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1067":
              case "1068":
              case "1228":
              case "1229":
                new PetMakeDamageEquipEffect(2, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1113":
              case "1114":
              case "1236":
              case "1237":
                new PetLuckMakeDamageEquipEffect(0, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1117":
                new PetRemoveDamageEquipEffect(1, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1115":
              case "1116":
              case "1243":
              case "1244":
                new PetAddBloodEquipEffect(1, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1238":
              case "1239":
              case "1240":
                new PetAddDamageEquipEffect(2, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1043":
              case "1044":
              case "1045":
                new PetUnlimitAddBloodEquipEffect(2, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1058":
              case "1059":
                new PetRevertBloodAllPlayerAroundEquipEffect(0, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1026":
              case "1027":
                new PetAddBloodAllPlayerAroundEquipEffect(3, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1063":
                new PetAddBloodForSelfEquipEffect(3, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1028":
                new PetAddBloodAllPlayerAroundEquipEffect(4, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1064":
                new PetAddBloodForSelfEquipEffect(4, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1080":
              case "1081":
                new PetAddBloodForTeamEquipEffect(0, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1118":
              case "1119":
                new PetAddDefendByCureEquipEffect(2, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1254":
              case "1255":
              case "1256":
                new PetReduceTargetAttackEquipEffect(3, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1257":
              case "1258":
                new PetAddGuardForTeamEquipEffect(2, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1259":
              case "1260":
                new PetRecoverBloodForTeamEquipEffect(2, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1268":
              case "1269":
                new PetRecoverMPForTeamEquipEffect(0, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1266":
              case "1267":
                new PetRemoveTagertMPEquipEffect(0, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1261":
              case "1262":
                new PetAddGodLuckEquipEffect(0, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1264":
              case "1265":
                new PetAddGodDamageEquipEffect(0, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1270":
              case "1271":
                new PetReduceTargetBloodEquipEffect(2, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1272":
              case "1273":
              case "1274":
                new PetAtomBombEquipEffect(0, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1040":
              case "1041":
              case "1042":
                new PetAddLuckLimitTurnEquipEffect(2, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1022":
              case "1023":
                new PetActiveGuardForTeamEquipEffect(0, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1024":
              case "1025":
                new PetActiveDamageForTeamEquipEffect(0, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1056":
              case "1057":
                new PetRecoverBloodForTeamInMapEquipEffect(0, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1074":
              case "1075":
                new PetSecondWeaponBonusPointEquipEffect(0, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1078":
              case "1079":
                new PetGuardSecondWeaponRecoverBloodEquipEffect(0, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1107":
                new PetAddHighMPEquipEffect(0, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1109":
              case "1110":
                new PetClearHighMPEquipEffect(0, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1092":
              case "1093":
                new PetBonusAttackForTeamEquipEffect(3, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1094":
              case "1095":
                new PetBonusDefendForTeamEquipEffect(3, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1096":
              case "1097":
                new PetBonusAgilityForTeamEquipEffect(3, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1098":
              case "1099":
                new PetBonusLuckyForTeamEquipEffect(3, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1100":
              case "1101":
                new PetBonusMaxHpForTeamEquipEffect(3, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1222":
                new PetStopMovingAllEnemyEffect(2, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1220":
              case "1221":
                new PetReduceGuardAllEnemyEquipEffect(2, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1214":
              case "1215":
                new PetBonusGuardBeginMatchEquipEffect(2, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1216":
              case "1217":
                new PetBonusMaxBloodBeginMatchEquipEffect(2, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1210":
              case "1211":
                new PetReduceBloodAllBattleEquipEffectcs(3, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1212":
              case "1213":
                new PetAddCritRateEquipEffect(3, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1208":
              case "1209":
                new PetReduceMpAllEnemyEquipEffect(0, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1204":
              case "1205":
                new PetReduceAttackAllEnemyEquipEffect(2, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1206":
              case "1207":
                new PetReduceDefendAllEnemyEquipEffect(2, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1201":
              case "1202":
              case "1203":
                new PetReduceBaseDamageTargetEquipEffect(3, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1150":
              case "1151":
              case "1152":
                new PetBurningBloodTargetEquipEffect(3, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1153":
              case "1154":
                new PetAddDamageEquipEffect(3, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1155":
              case "1156":
                new PetReduceBaseGuardEquipEffect(3, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1174":
              case "1175":
                new PetAttackedRecoverBloodEquipEffect(3, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1176":
              case "1177":
                new PetEnemyAttackBurningBloodEquipEffect(3, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1163":
              case "1164":
                new PetBonusAttackBeginMatchEquipEffect(0, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1165":
              case "1166":
                new PetBonusBaseDamageBeginMatchEquipEffect(0, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1161":
              case "1162":
                new PetDamageAllEnemyEquipEffect(0, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1178":
              case "1179":
              case "1180":
                new PetBuffAttackEquipEffect(3, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1181":
              case "1182":
              case "1183":
                new PetBuffBaseGuardForTeamEquipEffect(2, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1184":
              case "1185":
                new PetAddDamageEquipEffect(200, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1186":
              case "1187":
                new PetReduceBloodAllBattleEquipEffectcs(200, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1188":
              case "1189":
                new PetClearHellIceEquipEffectcs(0, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1190":
              case "1191":
                new PetBonusAgilityBeginMatchEquipEffect(0, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1192":
              case "1193":
                new PetBonusDefendTeamBeginMatchEquipEffect(0, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1198":
              case "1199":
                new PetAddCritRateEquipEffect(1, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1196":
              case "1197":
                new PetAddDamageEquipEffect(1, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
              case "1194":
              case "1195":
                new PetBuffAttackEquipEffect(1, probability, gameType, num, delay, elementID).Start((Living) this);
                break;
            }
          }
        }
      }
    }

    public void InitEqupedEffect(List<SqlDataProvider.Data.ItemInfo> equpedEffect)
    {
      this.EffectList.StopAllEffect();
      foreach (SqlDataProvider.Data.ItemInfo itemInfo in equpedEffect)
      {
        int index1 = 0;
        int index2 = 0;
        RuneTemplateInfo runeByTemplateId = RuneMgr.FindRuneByTemplateID(itemInfo.TemplateID);
        if (runeByTemplateId != null)
        {
          string[] strArray1 = runeByTemplateId.Attribute1.Split('|');
          string[] strArray2 = runeByTemplateId.Attribute2.Split('|');
          if (itemInfo.Hole1 > runeByTemplateId.BaseLevel)
          {
            if (strArray1.Length > 1)
              index1 = 1;
            if (strArray2.Length > 1)
              index2 = 1;
          }
          int type = runeByTemplateId.Type1;
          int int32 = Convert.ToInt32(strArray1[index1]);
          int probability = runeByTemplateId.Rate1;
          if (type == 39)
          {
            this.ReduceCritFisrtGem = int32;
            this.ReduceCritSecondGem = int32;
            int type2 = runeByTemplateId.Type2;
            if (this.DefenFisrtGem == 0)
              this.DefenFisrtGem = type2;
            else
              this.DefenSecondGem = type2;
          }
          if (type == 37 || type == 39)
          {
            type = runeByTemplateId.Type2;
            int32 = Convert.ToInt32(strArray2[index2]);
            probability = runeByTemplateId.Rate2;
          }
          switch (type)
          {
            case 1:
              new AddAttackEffect(int32, probability).Start((Living) this);
              break;
            case 2:
              new AddDefenceEffect(int32, probability, type).Start((Living) this);
              break;
            case 3:
              new AddAgilityEffect(int32, probability).Start((Living) this);
              break;
            case 4:
              new AddLuckyEffect(int32, probability).Start((Living) this);
              break;
            case 5:
              new AddDamageEffect(int32, probability).Start((Living) this);
              break;
            case 6:
              new ReduceDamageEffect(int32, probability, type).Start((Living) this);
              break;
            case 7:
              new AddBloodEffect(int32, probability).Start((Living) this);
              break;
            case 8:
              new FatalEffect(int32, probability).Start((Living) this);
              break;
            case 9:
              new IceFronzeEquipEffect(int32, probability).Start((Living) this);
              break;
            case 10:
              new NoHoleEquipEffect(int32, probability, type).Start((Living) this);
              break;
            case 11:
              new AtomBombEquipEffect(int32, probability).Start((Living) this);
              break;
            case 12:
              new ArmorPiercerEquipEffect(int32, probability).Start((Living) this);
              break;
            case 13:
              new AvoidDamageEffect(int32, probability, type).Start((Living) this);
              break;
            case 14:
              new MakeCriticalEffect(int32, probability).Start((Living) this);
              break;
            case 15:
              new AssimilateDamageEffect(int32, probability, type).Start((Living) this);
              break;
            case 16:
              new AssimilateBloodEffect(int32, probability).Start((Living) this);
              break;
            case 17:
              new SealEquipEffect(int32, probability).Start((Living) this);
              break;
            case 18:
              new AddTurnEquipEffect(int32, probability, runeByTemplateId.TemplateID).Start((Living) this);
              break;
            case 19:
              new AddDanderEquipEffect(int32, probability, type).Start((Living) this);
              break;
            case 20:
              new ReflexDamageEquipEffect(int32, probability).Start((Living) this);
              break;
            case 21:
              new ReduceStrengthEquipEffect(int32, probability).Start((Living) this);
              break;
            case 22:
              new ContinueReduceBloodEquipEffect(int32, probability).Start((Living) this);
              break;
            case 23:
              new LockDirectionEquipEffect(int32, probability).Start((Living) this);
              break;
            case 24:
              new AddBombEquipEffect(int32, probability).Start((Living) this);
              break;
            case 25:
              new ContinueReduceDamageEquipEffect(int32, probability).Start((Living) this);
              break;
            case 26:
              new RecoverBloodEffect(int32, probability, type).Start((Living) this);
              break;
            default:
              Console.WriteLine("Not Found Effect: " + (object) type);
              break;
          }
        }
      }
    }

    public virtual int AddEnegy(int value)
    {
      this.int_14 = value;
      if (this.m_syncAtTime)
        this.m_game.method_28((Living) this, 1, value);
      return value;
    }

    public bool ReduceEnergy(int value)
    {
      if (value > this.int_14)
        return false;
      this.int_14 -= value;
      return true;
    }

    public override bool TakeDamage(
      Living source,
      ref int damageAmount,
      ref int criticalAmount,
      string msg)
    {
      if ((source == this || source.Team == this.Team) && damageAmount + criticalAmount >= this.m_blood)
      {
        damageAmount = this.m_blood - 1;
        criticalAmount = 0;
      }
      bool damage = base.TakeDamage(source, ref damageAmount, ref criticalAmount, msg);
      if (this.IsLiving)
        this.AddDander((damageAmount * 2 / 5 + 5) / 2);
      return damage;
    }

    public void UseSpecialSkill()
    {
      if (this.Dander < 200)
        return;
      this.SetBall(this.int_11, true);
      this.int_19 = this.ballInfo_0.Amount;
      this.SetDander(0);
      this.OnPlayerUseDander();
    }

    public void SetBall(int ballId) => this.SetBall(ballId, false);

    public void SetBall(int ballId, bool special)
    {
      if (ballId == this.ballInfo_0.ID)
        return;
      if (BallMgr.FindBall(ballId) != null)
        this.ballInfo_0 = BallMgr.FindBall(ballId);
      this.m_game.method_39(this, special);
    }

    public void SetCurrentWeapon(SqlDataProvider.Data.ItemInfo item)
    {
      this.itemInfo_0 = item;
      BallConfigInfo ball = BallConfigMgr.FindBall(this.itemInfo_0.TemplateID);
      if (this.itemInfo_0.IsGold)
        ball = BallConfigMgr.FindBall(this.itemInfo_0.GoldEquip.TemplateID);
      if (this.ChangeSpecialBall > 0)
        ball = BallConfigMgr.FindBall(70396);
      this.int_10 = ball.Common;
      this.int_11 = ball.Special;
      this.int_12 = ball.CommonAddWound;
      this.int_13 = ball.CommonMultiBall;
      this.SetBall(this.int_10);
    }

    public void CalculatePlayerOffer(Player player)
    {
      if (this.m_game.RoomType != eRoomType.Match || this.m_game.GameType != eGameType.Guild && this.m_game.GameType != eGameType.Free || player.IsLiving)
        return;
      int num = this.Game.GameType != eGameType.Guild ? (this.PlayerDetail.PlayerCharacter.ConsortiaID == 0 || player.PlayerDetail.PlayerCharacter.ConsortiaID == 0 ? 1 : 3) : 10;
      if (num > player.PlayerDetail.PlayerCharacter.Offer)
        num = player.PlayerDetail.PlayerCharacter.Offer;
      if (num <= 0)
        return;
      this.GainOffer += num;
    }

    public void StartRotate(int rotation, int speed, string endPlay, int delay)
    {
      this.m_game.AddAction((IAction) new LivingRotateTurnAction(this, rotation, speed, endPlay, delay));
    }

    public void StartSpeedMult(int x, int y) => this.StartSpeedMult(x, y, 3000);

    public void StartSpeedMult(int x, int y, int delay)
    {
      Point point = new Point(x - this.X, y - this.Y);
      this.m_game.AddAction((IAction) new PlayerSpeedMultAction(this, new Point(this.X + point.X, this.Y + point.Y), delay));
    }

    public void StartGhostMoving()
    {
      if (this.TargetPoint.IsEmpty)
        return;
      Point point = new Point(this.TargetPoint.X - this.X, this.TargetPoint.Y - this.Y);
      if (point.Length() > 160.0)
        point.Normalize(160);
      this.m_game.AddAction((IAction) new GhostMoveAction(this, new Point(this.X + point.X, this.Y + point.Y)));
    }

    public override void SetXY(int x, int y)
    {
      if (this.m_x == x && this.m_y == y)
        return;
      int num1 = Math.Abs(this.m_x - x);
      int num2 = num1 * this.FightBuffers.ConsortionReduceEnergyUse / 100;
      this.m_x = x;
      this.m_y = y;
      if (this.IsLiving)
      {
        if (this.m_game.IsPVE())
        {
          ((PVEGame) this.m_game).method_69();
          if (((PVEGame) this.m_game).IsWorldCup() && ((PVEGame) this.m_game).SessionId == 0)
            num2 = 0;
        }
        if (num1 > 60 || this.LimitEnergy)
          return;
        this.int_14 -= num1 - num2;
        if (this.m_syncAtTime)
          this.m_game.method_33((Living) this, "energy2", this.int_14.ToString());
        this.OnPlayerMoving();
      }
      else
      {
        Rectangle rect = this.m_rect;
        rect.Offset(this.m_x, this.m_y);
        foreach (Physics physicalObject in this.m_map.FindPhysicalObjects(rect, (Physics) this))
        {
          if (physicalObject is Box)
          {
            Box box = physicalObject as Box;
            this.PickBox(box);
            this.OpenBox(box.Id);
          }
        }
      }
    }

    public override void Die()
    {
      if (!this.IsLiving)
        return;
      this.m_y -= 70;
      base.Die();
    }

    public override void PickBox(Box box)
    {
      this.arrayList_0.Add((object) box);
      base.PickBox(box);
    }

    public void OpenBox(int boxId)
    {
      Box box1 = (Box) null;
      foreach (Box box2 in this.arrayList_0)
      {
        if (box2.Id == boxId)
        {
          box1 = box2;
          break;
        }
      }
      if (box1 == null || box1.Item == null)
        return;
      SqlDataProvider.Data.ItemInfo cloneItem = box1.Item;
      switch (cloneItem.TemplateID)
      {
        case -1100:
          this.igamePlayer_0.AddGiftToken(cloneItem.Count);
          break;
        case -300:
          this.igamePlayer_0.AddMedal(cloneItem.Count);
          break;
        case -200:
          this.igamePlayer_0.AddMoney(cloneItem.Count);
          this.igamePlayer_0.LogAddMoney(AddMoneyType.Box, AddMoneyType.Box_Open, this.igamePlayer_0.PlayerCharacter.ID, cloneItem.Count, this.igamePlayer_0.PlayerCharacter.Money);
          break;
        case -100:
          this.igamePlayer_0.AddGold(cloneItem.Count);
          break;
        default:
          if (cloneItem.Template.CategoryID != 10)
          {
            this.igamePlayer_0.AddTemplate(cloneItem, eBageType.TempBag, cloneItem.Count, eGameView.dungeonTypeGet);
            break;
          }
          break;
      }
      this.arrayList_0.Remove((object) box1);
    }

    public override void PrepareNewTurn()
    {
      if (this.CurrentIsHitTarget)
        ++this.TotalHitTargetCount;
      this.int_14 = (int) this.Agility / 30 + 240;
      if (this.LimitEnergy)
        this.int_14 = this.TotalCureEnergy;
      if (this.FightBuffers.ConsortionAddEnergy > 0)
        this.int_14 += this.FightBuffers.ConsortionAddEnergy;
      this.PetEffects.CurrentUseSkill = 0;
      this.PetEffects.PetDelay = 0;
      this.SpecialSkillDelay = 0;
      this.int_18 = 1;
      this.int_19 = 1;
      this.EffectTrigger = false;
      this.PetEffectTrigger = false;
      --this.int_23;
      this.SetCurrentWeapon(this.PlayerDetail.MainWeapon);
      if (this.ballInfo_0.ID != this.int_10)
        this.ballInfo_0 = BallMgr.FindBall(this.int_10);
      if (this.m_game.RoomType == eRoomType.FightFootballTime)
        this.ballInfo_0 = BallMgr.FindBall(24);
      if (!this.IsLiving)
      {
        this.StartGhostMoving();
        this.TargetPoint = Point.Empty;
      }
      if (!this.PetEffects.StopMoving)
        this.SpeedMultX(3);
      base.PrepareNewTurn();
    }

    public override void PrepareSelfTurn()
    {
      base.PrepareSelfTurn();
      this.DefaultDelay = this.m_delay;
      --this.int_23;
      if (this.IsFrost)
        this.AddDelay(this.method_0());
      if (this.usersPetinfo_0 != null)
      {
        string skillEquip = this.usersPetinfo_0.SkillEquip;
        char[] chArray1 = new char[1]{ '|' };
        foreach (string str in skillEquip.Split(chArray1))
        {
          char[] chArray2 = new char[1]{ ',' };
          int key = int.Parse(str.Split(chArray2)[0]);
          if (this.dictionary_0.ContainsKey(key) && this.dictionary_0[key].Turn > 0)
            --this.dictionary_0[key].Turn;
        }
      }
      foreach (int key in this.HorseSkillEquip)
      {
        if (this.dictionary_1.ContainsKey(key) && this.dictionary_1[key].Turn > 0)
          --this.dictionary_1[key].Turn;
        else
          this.m_game.method_12((Living) this);
      }
      this.m_game.method_11((Living) this, this.PetSkillCD, this.HorseSkillCD);
    }

    public override void CollidedByObject(Physics phy)
    {
      base.CollidedByObject(phy);
      if (!(phy is SimpleBomb))
        return;
      this.OnCollidedByObject();
    }

    public override void StartAttacking()
    {
      if (this.IsAttacking)
        return;
      if (this.itemInfo_2 != null && this.m_blood < this.m_maxBlood && this.igamePlayer_0.RemoveHealstone())
        this.AddBlood(this.itemInfo_2.Template.Property2);
      this.AddDelay(this.method_0());
      base.StartAttacking();
    }

    private int method_0()
    {
      return (int) (1600.0 - 1200.0 * this.Agility / (this.Agility + 1200.0) + this.Attack / 10.0);
    }

    public override void Skip(int spendTime)
    {
      if (!this.IsAttacking)
        return;
      this.Game.method_4(this);
      this.int_15 = 0;
      this.AddDelay(100);
      this.AddDander(20);
      this.AddPetMP(10);
      base.Skip(spendTime);
    }

    public void PrepareShoot(byte speedTime)
    {
      int turnWaitTime = this.m_game.GetTurnWaitTime();
      this.AddDelay(((int) speedTime > turnWaitTime ? turnWaitTime : (int) speedTime) * 20);
      ++this.TotalShootCount;
      this.PassBallFail = false;
    }

    public bool CanUseSkill(int energy)
    {
      return this.int_14 >= energy && (this.IsAttacking || !this.IsLiving && this.Team == this.m_game.CurrentLiving.Team);
    }

    public bool UseHorseSkill(MountSkillTemplateInfo skillInfo)
    {
      if (!this.CanUseSkill(skillInfo.CostEnergy))
        return false;
      this.int_14 -= skillInfo.CostEnergy;
      this.m_delay += skillInfo.Delay;
      this.PetEffects.CurrentHorseSkill = skillInfo.ID;
      this.OnPlayerBuffSkillHorse();
      return true;
    }

    public void PetUseKill(int skillID, int type)
    {
      if (type == 2 && this.dictionary_1.ContainsKey(skillID))
      {
        MountSkillTemplateInfo skillInfo = this.dictionary_1[skillID];
        if (skillInfo.Count >= skillInfo.UseCount || !this.UseHorseSkill(skillInfo))
          return;
        ++skillInfo.Count;
        skillInfo.Turn = skillInfo.ColdDown;
        int int_6 = skillInfo.UseCount - skillInfo.Count;
        this.m_game.method_47(this, skillID, true, type, int_6);
        this.dictionary_1[skillID] = skillInfo;
      }
      else
      {
        if (!this.PetSkillCD.ContainsKey(skillID))
          return;
        PetSkillInfo petSkill = PetMgr.FindPetSkill(skillID);
        if (this.PetMP > 0 && this.PetMP >= petSkill.CostMP)
        {
          if (petSkill.NewBallID != -1)
          {
            this.m_delay += petSkill.Delay;
            this.SetBall(petSkill.NewBallID);
          }
          this.PetMP -= petSkill.CostMP;
          if (petSkill.DamageCrit > 0)
          {
            this.PetEffects.CritActive = true;
            this.CurrentDamagePlus += (float) (petSkill.DamageCrit / 100);
          }
          this.PetEffects.IsPetUseSkill = true;
          this.PetEffects.CurrentUseSkill = skillID;
          this.m_game.method_46(this, type, 0);
          this.OnPlayerBuffSkillPet();
          this.dictionary_0[skillID].Turn = petSkill.ColdDown;
          this.m_game.method_12((Living) this);
        }
        else
          this.igamePlayer_0.SendMessage(LanguageMgr.GetTranslation("Player.Msg1"));
      }
    }

    public virtual void Revive(int blood, int x, int y)
    {
      this.Revive();
      this.Blood = blood;
      this.m_game.method_45((Living) this, blood, x, y);
    }

    public bool Shoot(int x, int y, int force, int angle)
    {
      if (this.int_18 == 1)
        this.PetEffects.ActivePetHit = true;
      if (this.int_18 > 0)
      {
        this.OnPlayerShoot();
        int bombId = this.ballInfo_0.ID;
        if (this.int_19 == 1 && !this.IsSpecialSkill)
        {
          if (this.Prop == 20002)
            bombId = this.int_13;
          if (this.Prop == 20008)
            bombId = this.int_12;
        }
        this.OnBeforePlayerShoot();
        if (this.IsSpecialSkill)
          this.SpecialSkillDelay = 2000;
        if (this.ShootImp(bombId, x, y, force, angle, this.int_19, this.ShootCount))
        {
          if (bombId == 4)
            this.m_game.AddAction((IAction) new FightAchievementAction((Living) this, 2, this.Direction, 1200));
          --this.int_18;
          if (this.int_18 <= 0 || !this.IsLiving)
          {
            this.StopAttacking();
            this.AddDelay(this.ballInfo_0.Delay + this.itemInfo_0.Template.Property8);
            this.AddDander(20);
            this.AddPetMP(10);
            this.int_15 = 0;
            if (this.CanGetProp)
            {
              List<SqlDataProvider.Data.ItemInfo> info = (List<SqlDataProvider.Data.ItemInfo>) null;
              if (DropInventory.FireDrop(this.m_game.RoomType, ref info) && info != null)
              {
                foreach (SqlDataProvider.Data.ItemInfo cloneItem in info)
                {
                  if (cloneItem != null && this.VaneOpen && cloneItem.Template.CategoryID != 10)
                    this.PlayerDetail.AddTemplate(cloneItem, eBageType.TempBag, cloneItem.Count, eGameView.dungeonTypeGet);
                }
              }
            }
          }
          this.OnAfterPlayerShoot();
          return true;
        }
      }
      return false;
    }

    public bool CanUseItem(ItemTemplateInfo item)
    {
      return this.int_14 >= item.Property4 && (this.IsAttacking || !this.IsLiving && this.Team == this.m_game.CurrentLiving.Team);
    }

    public bool UseItem(ItemTemplateInfo item)
    {
      if (!this.CanUseItem(item))
        return false;
      this.int_14 -= item.Property4;
      if (this.LimitEnergy)
        this.TotalCureEnergy -= item.Property4;
      this.m_delay += item.Property5;
      this.m_game.method_52((Living) this, -2, -2, item.TemplateID, this);
      SpellMgr.ExecuteSpell(this.m_game, this, item);
      return true;
    }

    public void UseFlySkill()
    {
      if (this.int_23 > 0 && this.Game.RoomType == eRoomType.BattleRoom)
      {
        --this.int_23;
        this.m_game.method_51(this, -2, -2, Player.int_22);
        this.SetBall(3);
      }
      else
      {
        this.m_game.method_51(this, -2, -2, Player.int_22);
        this.SetBall(3);
      }
    }

    public void UseSecondWeapon()
    {
      if (!this.CanUseItem(this.itemInfo_1.Template))
        return;
      if (this.itemInfo_1.Template.Property3 == 31)
      {
        new AddGuardEquipEffect((int) this.getHertAddition(this.itemInfo_1), 1).Start((Living) this);
        this.OnPlayerGuard();
      }
      else
      {
        this.SetCurrentWeapon(this.itemInfo_1);
        this.OnPlayerCure();
      }
      this.ShootCount = 1;
      this.int_14 -= this.itemInfo_1.Template.Property4;
      this.m_delay += this.itemInfo_1.Template.Property5;
      this.m_game.method_51(this, -2, -2, this.itemInfo_1.Template.TemplateID);
      if (this.int_21 > 0)
      {
        --this.int_21;
        this.m_game.method_50(this, this.int_21);
      }
    }

    public bool IsCure()
    {
      switch (this.Weapon.TemplateID)
      {
        case 17000:
        case 17001:
        case 17002:
        case 17005:
        case 17007:
        case 17010:
          return true;
        case 17100:
        case 17102:
          return true;
        default:
          return false;
      }
    }

    public void DeadLink()
    {
      this.bool_9 = false;
      if (!this.IsLiving)
        return;
      this.Die();
    }

    public bool CheckShootPoint(int x, int y)
    {
      int num = Math.Abs(this.X - x);
      if (num <= 100)
        return true;
      string userName = this.igamePlayer_0.PlayerCharacter.UserName;
      string nickName = this.igamePlayer_0.PlayerCharacter.NickName;
      Console.WriteLine("Shoot fail point: {0}", (object) num);
      return false;
    }

    protected void OnPlayerMoving()
    {
      if (this.playerEventHandle_0 == null)
        return;
      this.playerEventHandle_0(this);
    }

    protected void OnAfterPlayerShoot()
    {
      if (this.playerEventHandle_1 == null)
        return;
      this.playerEventHandle_1(this);
    }

    protected void OnBeforePlayerShoot()
    {
      if (this.playerEventHandle_2 == null)
        return;
      this.playerEventHandle_2(this);
    }

    protected void OnLoadingCompleted()
    {
      if (this.playerEventHandle_3 == null)
        return;
      this.playerEventHandle_3(this);
    }

    public void OnPlayerShoot()
    {
      if (this.playerEventHandle_4 == null)
        return;
      this.playerEventHandle_4(this);
    }

    public void OnPlayerCure()
    {
      if (this.playerEventHandle_5 == null)
        return;
      this.playerEventHandle_5(this);
    }

    public void OnPlayerGuard()
    {
      if (this.playerEventHandle_6 == null)
        return;
      this.playerEventHandle_6(this);
    }

    public void OnPlayerBuffSkillPet()
    {
      if (this.playerEventHandle_7 == null)
        return;
      this.playerEventHandle_7(this);
    }

    public void OnPlayerBuffSkillHorse()
    {
      if (this.playerEventHandle_8 == null)
        return;
      this.playerEventHandle_8(this);
    }

    protected void OnCollidedByObject()
    {
      if (this.playerEventHandle_9 == null)
        return;
      this.playerEventHandle_9(this);
    }

    public void OnPlayerUseDander()
    {
      if (this.playerEventHandle_10 == null)
        return;
      this.playerEventHandle_10(this);
    }

    public override void OnAfterKillingLiving(Living target, int damageAmount, int criticalAmount)
    {
      base.OnAfterKillingLiving(target, damageAmount, criticalAmount);
      if (target is Player)
      {
        this.igamePlayer_0.OnKillingLiving((AbstractGame) this.m_game, 1, target.Id, target.IsLiving, damageAmount + criticalAmount);
      }
      else
      {
        int id = 0;
        if (target is SimpleBoss)
          id = (target as SimpleBoss).NpcInfo.ID;
        if (target is SimpleNpc)
          id = (target as SimpleNpc).NpcInfo.ID;
        this.igamePlayer_0.OnKillingLiving((AbstractGame) this.m_game, 2, id, target.IsLiving, damageAmount + criticalAmount);
      }
    }
  }
}
