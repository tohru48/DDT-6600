// Decompiled with JetBrains decompiler
// Type: Game.Logic.Phy.Object.Living
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Bussiness;
using Game.Base.Packets;
using Game.Logic.Actions;
using Game.Logic.Effects;
using Game.Logic.HorseEffects;
using Game.Logic.PetEffects;
using Game.Logic.Phy.Actions;
using Game.Logic.Phy.Maps;
using Game.Logic.Phy.Maths;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Threading;

#nullable disable
namespace Game.Logic.Phy.Object
{
  public class Living : Physics
  {
    protected BaseGame m_game;
    protected int m_maxBlood;
    protected int m_blood;
    private int int_0;
    private string string_0;
    private string string_1;
    private string string_2;
    private Rectangle rectangle_0;
    private int int_1;
    private int int_2;
    public int m_direction;
    private eLivingType eLivingType_0;
    private Random random_0;
    public double BaseDamage;
    public double BaseGuard;
    public double Defence;
    public double Attack;
    public double Agility;
    public double Lucky;
    public double MagicAttack;
    public double MagicDefence;
    public int Grade;
    public int Experience;
    public float CurrentDamagePlus;
    public float CurrentShootMinus;
    public bool IgnoreArmor;
    public int IgnoreGuard;
    public bool AddArmor;
    public bool ControlBall;
    public int ReduceCritFisrtGem;
    public int ReduceCritSecondGem;
    public int DefenFisrtGem;
    public int DefenSecondGem;
    public int DefendActiveGem;
    public int AttackGemLimit;
    public bool NoHoleTurn;
    public bool CurrentIsHitTarget;
    public int FlyingPartical;
    public int TurnNum;
    public int TotalHurt;
    public int TotalDameLiving;
    public int TotalHitTargetCount;
    public int TotalShootCount;
    public int TotalKill;
    public int MaxBeatDis;
    public int EffectsCount;
    public int ShootMovieDelay;
    public List<int> ScoreArr;
    public Point LastPoint;
    public bool PassBallFail;
    private HorseEffectList horseEffectList_0;
    private PetEffectList petEffectList_0;
    private EffectList effectList_0;
    public bool EffectTrigger;
    public bool PetEffectTrigger;
    protected bool m_syncAtTime;
    private bool bool_0;
    private PetEffectInfo petEffectInfo_0;
    private bool bool_1;
    private FightBufferInfo fightBufferInfo_0;
    public bool TiredShoot;
    public bool ClearBuff;
    public bool LockMove;
    public bool BombFoul;
    private LivingConfig livingConfig_0;
    private int int_3;
    private int int_4;
    private bool bool_2;
    protected static int MOVE_SPEED = 2;
    protected static int GHOST_MOVE_SPEED = 8;
    protected static int StepX = 3;
    protected static int StepY = 7;
    private int int_5;
    private bool bool_3;
    private bool bool_4;
    private bool bool_5;
    private bool bool_6;
    private bool bool_7;
    private LivingEventHandle livingEventHandle_0;
    private LivingTakedDamageEventHandle livingTakedDamageEventHandle_0;
    private LivingTakedDamageEventHandle livingTakedDamageEventHandle_1;
    private LivingEventHandle livingEventHandle_1;
    private LivingEventHandle livingEventHandle_2;
    private LivingEventHandle livingEventHandle_3;
    private LivingEventHandle livingEventHandle_4;
    private LivingEventHandle livingEventHandle_5;
    private KillLivingEventHanlde killLivingEventHanlde_0;
    private KillLivingEventHanlde killLivingEventHanlde_1;

    public event LivingEventHandle Died
    {
      add
      {
        LivingEventHandle livingEventHandle = this.livingEventHandle_0;
        LivingEventHandle comparand;
        do
        {
          comparand = livingEventHandle;
          livingEventHandle = Interlocked.CompareExchange<LivingEventHandle>(ref this.livingEventHandle_0, comparand + value, comparand);
        }
        while (livingEventHandle != comparand);
      }
      remove
      {
        LivingEventHandle livingEventHandle = this.livingEventHandle_0;
        LivingEventHandle comparand;
        do
        {
          comparand = livingEventHandle;
          livingEventHandle = Interlocked.CompareExchange<LivingEventHandle>(ref this.livingEventHandle_0, comparand - value, comparand);
        }
        while (livingEventHandle != comparand);
      }
    }

    public event LivingTakedDamageEventHandle BeforeTakeDamage
    {
      add
      {
        LivingTakedDamageEventHandle damageEventHandle = this.livingTakedDamageEventHandle_0;
        LivingTakedDamageEventHandle comparand;
        do
        {
          comparand = damageEventHandle;
          damageEventHandle = Interlocked.CompareExchange<LivingTakedDamageEventHandle>(ref this.livingTakedDamageEventHandle_0, comparand + value, comparand);
        }
        while (damageEventHandle != comparand);
      }
      remove
      {
        LivingTakedDamageEventHandle damageEventHandle = this.livingTakedDamageEventHandle_0;
        LivingTakedDamageEventHandle comparand;
        do
        {
          comparand = damageEventHandle;
          damageEventHandle = Interlocked.CompareExchange<LivingTakedDamageEventHandle>(ref this.livingTakedDamageEventHandle_0, comparand - value, comparand);
        }
        while (damageEventHandle != comparand);
      }
    }

    public event LivingTakedDamageEventHandle TakePlayerDamage
    {
      add
      {
        LivingTakedDamageEventHandle damageEventHandle = this.livingTakedDamageEventHandle_1;
        LivingTakedDamageEventHandle comparand;
        do
        {
          comparand = damageEventHandle;
          damageEventHandle = Interlocked.CompareExchange<LivingTakedDamageEventHandle>(ref this.livingTakedDamageEventHandle_1, comparand + value, comparand);
        }
        while (damageEventHandle != comparand);
      }
      remove
      {
        LivingTakedDamageEventHandle damageEventHandle = this.livingTakedDamageEventHandle_1;
        LivingTakedDamageEventHandle comparand;
        do
        {
          comparand = damageEventHandle;
          damageEventHandle = Interlocked.CompareExchange<LivingTakedDamageEventHandle>(ref this.livingTakedDamageEventHandle_1, comparand - value, comparand);
        }
        while (damageEventHandle != comparand);
      }
    }

    public event LivingEventHandle BeginNextTurn
    {
      add
      {
        LivingEventHandle livingEventHandle = this.livingEventHandle_1;
        LivingEventHandle comparand;
        do
        {
          comparand = livingEventHandle;
          livingEventHandle = Interlocked.CompareExchange<LivingEventHandle>(ref this.livingEventHandle_1, comparand + value, comparand);
        }
        while (livingEventHandle != comparand);
      }
      remove
      {
        LivingEventHandle livingEventHandle = this.livingEventHandle_1;
        LivingEventHandle comparand;
        do
        {
          comparand = livingEventHandle;
          livingEventHandle = Interlocked.CompareExchange<LivingEventHandle>(ref this.livingEventHandle_1, comparand - value, comparand);
        }
        while (livingEventHandle != comparand);
      }
    }

    public event LivingEventHandle BeginSelfTurn
    {
      add
      {
        LivingEventHandle livingEventHandle = this.livingEventHandle_2;
        LivingEventHandle comparand;
        do
        {
          comparand = livingEventHandle;
          livingEventHandle = Interlocked.CompareExchange<LivingEventHandle>(ref this.livingEventHandle_2, comparand + value, comparand);
        }
        while (livingEventHandle != comparand);
      }
      remove
      {
        LivingEventHandle livingEventHandle = this.livingEventHandle_2;
        LivingEventHandle comparand;
        do
        {
          comparand = livingEventHandle;
          livingEventHandle = Interlocked.CompareExchange<LivingEventHandle>(ref this.livingEventHandle_2, comparand - value, comparand);
        }
        while (livingEventHandle != comparand);
      }
    }

    public event LivingEventHandle BeginAttacking
    {
      add
      {
        LivingEventHandle livingEventHandle = this.livingEventHandle_3;
        LivingEventHandle comparand;
        do
        {
          comparand = livingEventHandle;
          livingEventHandle = Interlocked.CompareExchange<LivingEventHandle>(ref this.livingEventHandle_3, comparand + value, comparand);
        }
        while (livingEventHandle != comparand);
      }
      remove
      {
        LivingEventHandle livingEventHandle = this.livingEventHandle_3;
        LivingEventHandle comparand;
        do
        {
          comparand = livingEventHandle;
          livingEventHandle = Interlocked.CompareExchange<LivingEventHandle>(ref this.livingEventHandle_3, comparand - value, comparand);
        }
        while (livingEventHandle != comparand);
      }
    }

    public event LivingEventHandle BeginAttacked
    {
      add
      {
        LivingEventHandle livingEventHandle = this.livingEventHandle_4;
        LivingEventHandle comparand;
        do
        {
          comparand = livingEventHandle;
          livingEventHandle = Interlocked.CompareExchange<LivingEventHandle>(ref this.livingEventHandle_4, comparand + value, comparand);
        }
        while (livingEventHandle != comparand);
      }
      remove
      {
        LivingEventHandle livingEventHandle = this.livingEventHandle_4;
        LivingEventHandle comparand;
        do
        {
          comparand = livingEventHandle;
          livingEventHandle = Interlocked.CompareExchange<LivingEventHandle>(ref this.livingEventHandle_4, comparand - value, comparand);
        }
        while (livingEventHandle != comparand);
      }
    }

    public event LivingEventHandle EndAttacking
    {
      add
      {
        LivingEventHandle livingEventHandle = this.livingEventHandle_5;
        LivingEventHandle comparand;
        do
        {
          comparand = livingEventHandle;
          livingEventHandle = Interlocked.CompareExchange<LivingEventHandle>(ref this.livingEventHandle_5, comparand + value, comparand);
        }
        while (livingEventHandle != comparand);
      }
      remove
      {
        LivingEventHandle livingEventHandle = this.livingEventHandle_5;
        LivingEventHandle comparand;
        do
        {
          comparand = livingEventHandle;
          livingEventHandle = Interlocked.CompareExchange<LivingEventHandle>(ref this.livingEventHandle_5, comparand - value, comparand);
        }
        while (livingEventHandle != comparand);
      }
    }

    public event KillLivingEventHanlde AfterKillingLiving
    {
      add
      {
        KillLivingEventHanlde livingEventHanlde = this.killLivingEventHanlde_0;
        KillLivingEventHanlde comparand;
        do
        {
          comparand = livingEventHanlde;
          livingEventHanlde = Interlocked.CompareExchange<KillLivingEventHanlde>(ref this.killLivingEventHanlde_0, comparand + value, comparand);
        }
        while (livingEventHanlde != comparand);
      }
      remove
      {
        KillLivingEventHanlde livingEventHanlde = this.killLivingEventHanlde_0;
        KillLivingEventHanlde comparand;
        do
        {
          comparand = livingEventHanlde;
          livingEventHanlde = Interlocked.CompareExchange<KillLivingEventHanlde>(ref this.killLivingEventHanlde_0, comparand - value, comparand);
        }
        while (livingEventHanlde != comparand);
      }
    }

    public event KillLivingEventHanlde AfterKilledByLiving
    {
      add
      {
        KillLivingEventHanlde livingEventHanlde = this.killLivingEventHanlde_1;
        KillLivingEventHanlde comparand;
        do
        {
          comparand = livingEventHanlde;
          livingEventHanlde = Interlocked.CompareExchange<KillLivingEventHanlde>(ref this.killLivingEventHanlde_1, comparand + value, comparand);
        }
        while (livingEventHanlde != comparand);
      }
      remove
      {
        KillLivingEventHanlde livingEventHanlde = this.killLivingEventHanlde_1;
        KillLivingEventHanlde comparand;
        do
        {
          comparand = livingEventHanlde;
          livingEventHanlde = Interlocked.CompareExchange<KillLivingEventHanlde>(ref this.killLivingEventHanlde_1, comparand - value, comparand);
        }
        while (livingEventHanlde != comparand);
      }
    }

    public LivingConfig Config
    {
      get => this.livingConfig_0;
      set => this.livingConfig_0 = value;
    }

    public PetEffectInfo PetEffects
    {
      get => this.petEffectInfo_0;
      set => this.petEffectInfo_0 = value;
    }

    public FightBufferInfo FightBuffers
    {
      get => this.fightBufferInfo_0;
      set => this.fightBufferInfo_0 = value;
    }

    public bool VaneOpen
    {
      get => this.bool_1;
      set => this.bool_1 = value;
    }

    public bool isPet
    {
      get => this.bool_0;
      set => this.bool_0 = value;
    }

    public string ActionStr
    {
      get => this.string_1;
      set => this.string_1 = value;
    }

    public BaseGame Game => this.m_game;

    public string Name => this.string_0;

    public string ModelId => this.string_2;

    public int Team => this.int_0;

    public bool SyncAtTime
    {
      get => this.m_syncAtTime;
      set => this.m_syncAtTime = value;
    }

    public int FallCount
    {
      get => this.int_3;
      set => this.int_3 = value;
    }

    public int FindCount
    {
      get => this.int_4;
      set => this.int_4 = value;
    }

    public int Direction
    {
      get => this.m_direction;
      set
      {
        if (this.m_direction == value)
          return;
        this.m_direction = value;
        this.SetRect(-this.m_rect.X - this.m_rect.Width, this.m_rect.Y, this.m_rect.Width, this.m_rect.Height);
        this.SetRectBomb(-this.m_rectBomb.X - this.m_rectBomb.Width, this.m_rectBomb.Y, this.m_rectBomb.Width, this.m_rectBomb.Height);
        this.SetRelateDemagemRect(-this.rectangle_0.X - this.rectangle_0.Width, this.rectangle_0.Y, this.rectangle_0.Width, this.rectangle_0.Height);
        if (this.m_syncAtTime)
          this.m_game.vrgYhrgvPg(this);
      }
    }

    public eLivingType Type
    {
      get => this.eLivingType_0;
      set => this.eLivingType_0 = value;
    }

    public bool IsSay { get; set; }

    public EffectList EffectList => this.effectList_0;

    public PetEffectList PetEffectList => this.petEffectList_0;

    public HorseEffectList HorseEffectList => this.horseEffectList_0;

    public bool IsAttacking => this.bool_2;

    public int SpecialSkillDelay
    {
      get => this.int_5;
      set => this.int_5 = value;
    }

    public bool IsHoldBall => this.bool_7;

    public bool IsFrost
    {
      get => this.bool_3;
      set
      {
        if (this.bool_3 == value)
          return;
        this.bool_3 = value;
        if (this.m_syncAtTime)
          this.m_game.method_30(this);
      }
    }

    public bool IsNoHole
    {
      get => this.bool_5;
      set
      {
        if (this.bool_5 == value)
          return;
        this.bool_5 = value;
        if (this.m_syncAtTime)
          this.m_game.method_31(this);
      }
    }

    public bool IsHide
    {
      get => this.bool_4;
      set
      {
        if (this.bool_4 == value)
          return;
        this.bool_4 = value;
        if (this.m_syncAtTime)
          this.m_game.method_32(this);
      }
    }

    public int State
    {
      get => this.int_1;
      set
      {
        if (this.int_1 == value)
          return;
        this.int_1 = value;
        if (this.m_syncAtTime)
          this.m_game.method_57(this);
      }
    }

    public int DoAction
    {
      get => this.int_2;
      set
      {
        if (this.int_2 == value)
          return;
        this.int_2 = value;
      }
    }

    public int MaxBlood
    {
      get => this.m_maxBlood;
      set => this.m_maxBlood = value;
    }

    public int Blood
    {
      get => this.m_blood;
      set => this.m_blood = value;
    }

    public Living(
      int id,
      BaseGame game,
      int team,
      string name,
      string modelId,
      int maxBlood,
      int immunity,
      int direction)
      : base(id)
    {
      this.BaseDamage = 10.0;
      this.BaseGuard = 10.0;
      this.Defence = 10.0;
      this.Attack = 10.0;
      this.Agility = 10.0;
      this.Lucky = 10.0;
      this.MagicAttack = 10.0;
      this.MagicDefence = 10.0;
      this.Grade = 1;
      this.Experience = 10;
      this.bool_1 = false;
      this.bool_0 = false;
      this.string_1 = "";
      this.m_game = game;
      this.int_0 = team;
      this.string_0 = name;
      this.string_2 = modelId;
      this.m_maxBlood = maxBlood;
      this.m_direction = direction;
      this.int_1 = 0;
      this.int_2 = -1;
      this.MaxBeatDis = 100;
      this.AddArmor = false;
      this.ReduceCritFisrtGem = 0;
      this.ReduceCritSecondGem = 0;
      this.DefenFisrtGem = 0;
      this.DefenSecondGem = 0;
      this.DefendActiveGem = 0;
      this.AttackGemLimit = 0;
      this.effectList_0 = new EffectList(this, immunity);
      this.petEffectList_0 = new PetEffectList(this, immunity);
      this.horseEffectList_0 = new HorseEffectList(this, immunity);
      this.fightBufferInfo_0 = new FightBufferInfo();
      this.SetupPetEffect();
      this.livingConfig_0 = new LivingConfig();
      this.m_syncAtTime = true;
      this.eLivingType_0 = eLivingType.Living;
      this.random_0 = new Random();
      this.ScoreArr = new List<int>();
    }

    public void SetupPetEffect()
    {
      this.petEffectInfo_0 = new PetEffectInfo();
      this.petEffectInfo_0.CritActive = false;
      this.petEffectInfo_0.ActivePetHit = false;
      this.petEffectInfo_0.PetDelay = 0;
      this.petEffectInfo_0.PetBaseAtt = 0;
      this.petEffectInfo_0.CurrentUseSkill = 0;
      this.petEffectInfo_0.ActiveGuard = false;
    }

    public void SetRelateDemagemRect(int x, int y, int width, int height)
    {
      this.rectangle_0.X = x;
      this.rectangle_0.Y = y;
      this.rectangle_0.Width = width;
      this.rectangle_0.Height = height;
    }

    public void DemagemRect(int x, int y, int width, int height)
    {
      this.rectangle_0.Width = width;
      this.rectangle_0.Height = height;
    }

    public Point GetShootPoint()
    {
      return this is SimpleBoss ? (this.m_direction <= 0 ? new Point(this.X + ((SimpleBoss) this).NpcInfo.FireX, this.Y + ((SimpleBoss) this).NpcInfo.FireY) : new Point(this.X - ((SimpleBoss) this).NpcInfo.FireX, this.Y + ((SimpleBoss) this).NpcInfo.FireY)) : (this.m_direction <= 0 ? new Point(this.X + this.m_rect.X - 5, this.Y + this.m_rect.Y - 5) : new Point(this.X - this.m_rect.X + 5, this.Y + this.m_rect.Y - 5));
    }

    public Rectangle GetDirectDemageRect()
    {
      return this.m_direction <= 0 ? new Rectangle(this.X + this.rectangle_0.X, this.Y + this.rectangle_0.Y, this.rectangle_0.Width, this.rectangle_0.Height) : new Rectangle(this.X - this.rectangle_0.X, this.Y + this.rectangle_0.Y, this.rectangle_0.Width, this.rectangle_0.Height);
    }

    public List<Rectangle> GetDirectBoudRect()
    {
      return new List<Rectangle>()
      {
        this.m_direction > 0 ? new Rectangle(this.X - this.Bound.X, this.Y + this.Bound.Y, this.Bound.Width, this.Bound.Height) : new Rectangle(this.X + this.Bound.X, this.Y + this.Bound.Y, this.Bound.Width, this.Bound.Height),
        this.m_direction > 0 ? new Rectangle(this.X - this.Bound1.X, this.Y + this.Bound1.Y, this.Bound1.Width, this.Bound1.Height) : new Rectangle(this.X + this.Bound1.X, this.Y + this.Bound1.Y, this.Bound1.Width, this.Bound1.Height)
      };
    }

    public double Distance(Point p)
    {
      List<double> source = new List<double>();
      Rectangle directDemageRect = this.GetDirectDemageRect();
      for (int x = directDemageRect.X; x <= directDemageRect.X + directDemageRect.Width; x += 10)
      {
        source.Add(Math.Sqrt((double) ((x - p.X) * (x - p.X) + (directDemageRect.Y - p.Y) * (directDemageRect.Y - p.Y))));
        source.Add(Math.Sqrt((double) ((x - p.X) * (x - p.X) + (directDemageRect.Y + directDemageRect.Height - p.Y) * (directDemageRect.Y + directDemageRect.Height - p.Y))));
      }
      for (int y = directDemageRect.Y; y <= directDemageRect.Y + directDemageRect.Height; y += 10)
      {
        source.Add(Math.Sqrt((double) ((directDemageRect.X - p.X) * (directDemageRect.X - p.X) + (y - p.Y) * (y - p.Y))));
        source.Add(Math.Sqrt((double) ((directDemageRect.X + directDemageRect.Width - p.X) * (directDemageRect.X + directDemageRect.Width - p.X) + (y - p.Y) * (y - p.Y))));
      }
      return source.Min();
    }

    public double BoundDistance(Point p)
    {
      List<double> source = new List<double>();
      foreach (Rectangle rectangle in this.GetDirectBoudRect())
      {
        for (int x = rectangle.X; x <= rectangle.X + rectangle.Width; x += 10)
        {
          source.Add(Math.Sqrt((double) ((x - p.X) * (x - p.X) + (rectangle.Y - p.Y) * (rectangle.Y - p.Y))));
          source.Add(Math.Sqrt((double) ((x - p.X) * (x - p.X) + (rectangle.Y + rectangle.Height - p.Y) * (rectangle.Y + rectangle.Height - p.Y))));
        }
        for (int y = rectangle.Y; y <= rectangle.Y + rectangle.Height; y += 10)
        {
          source.Add(Math.Sqrt((double) ((rectangle.X - p.X) * (rectangle.X - p.X) + (y - p.Y) * (y - p.Y))));
          source.Add(Math.Sqrt((double) ((rectangle.X + rectangle.Width - p.X) * (rectangle.X + rectangle.Width - p.X) + (y - p.Y) * (y - p.Y))));
        }
      }
      return source.Min();
    }

    public virtual void Reset()
    {
      this.m_blood = this.m_maxBlood;
      this.bool_3 = false;
      this.bool_4 = false;
      this.bool_5 = false;
      this.m_isLiving = true;
      this.TurnNum = 0;
      this.TotalHurt = 0;
      this.TotalKill = 0;
      this.TotalShootCount = 0;
      this.TotalHitTargetCount = 0;
    }

    public virtual void PickBox(Box box)
    {
      box.UserID = this.Id;
      box.Die();
      if (!this.m_syncAtTime)
        return;
      this.m_game.method_40(this, box.Id, 0, "");
    }

    public virtual void PickBall(Ball ball)
    {
      ball.Die();
      string currentAction = ball.CurrentAction;
      ball.PlayMovie(ball.ActionMapping[currentAction], 1000, 0);
    }

    public override void PrepareNewTurn()
    {
      this.IgnoreGuard = 0;
      this.ShootMovieDelay = 0;
      this.CurrentDamagePlus = 1f;
      this.CurrentShootMinus = 1f;
      this.IgnoreArmor = false;
      this.ControlBall = false;
      this.NoHoleTurn = false;
      this.CurrentIsHitTarget = false;
      this.PrepareAttackGemLilit();
      this.PrepareDefendGem();
      this.OnBeginNewTurn();
      this.BombFoul = false;
      this.TiredShoot = false;
      this.ClearBuff = false;
      this.LockMove = false;
    }

    public virtual void PrepareSelfTurn() => this.OnBeginSelfTurn();

    public void StartAttacked() => this.OnStartAttacked();

    public void PrepareAttackGemLilit()
    {
      if (this.AttackGemLimit <= 0)
        return;
      --this.AttackGemLimit;
    }

    public void PrepareDefendGem()
    {
      if (this.DefenFisrtGem > 0 && this.DefenSecondGem > 0)
      {
        int[] numArray = new int[2]
        {
          this.DefenFisrtGem,
          this.DefenSecondGem
        };
        int index = this.random_0.Next(numArray.Length);
        this.DefendActiveGem = numArray[index];
      }
      else
        this.DefendActiveGem = this.DefenFisrtGem;
    }

    public virtual void StartAttacking()
    {
      if (this.bool_2)
        return;
      this.bool_2 = true;
      this.OnStartAttacking();
    }

    public virtual void StopAttacking()
    {
      if (!this.bool_2)
        return;
      this.bool_2 = false;
      this.OnStopAttacking();
    }

    public override void CollidedByObject(Physics phy)
    {
      if (!(phy is SimpleBomb))
        return;
      ((SimpleBomb) phy).Bomb();
    }

    public void SetXY(int x, int y, int delay)
    {
      this.m_game.AddAction((IAction) new LivingDirectSetXYAction(this, x, y, delay));
    }

    public void AddEffect(AbstractEffect effect, int delay)
    {
      this.m_game.AddAction((IAction) new LivingDelayEffectAction(this, effect, delay));
    }

    public void AddPetEffect(AbstractPetEffect effect, int delay)
    {
      this.m_game.AddAction((IAction) new LivingDelayPetEffectAction(this, effect, delay));
    }

    public void AddHorseEffect(AbstractHorseEffect effect, int delay)
    {
      this.m_game.AddAction((IAction) new LivingDelayHorseEffectAction(this, effect, delay));
    }

    public void Say(string msg, int type, int delay, int finishTime)
    {
      this.m_game.AddAction((IAction) new LivingSayAction(this, msg, type, delay, finishTime));
    }

    public void Say(string msg, int type, int delay)
    {
      this.m_game.AddAction((IAction) new LivingSayAction(this, msg, type, delay, 1000));
    }

    public bool MoveTo(int x, int y, string action, int delay, string sAction, int speed)
    {
      return this.MoveTo(x, y, action, delay, sAction, speed, (LivingCallBack) null);
    }

    public bool MoveTo(
      int x,
      int y,
      string action,
      int delay,
      string sAction,
      int speed,
      LivingCallBack callback)
    {
      return this.MoveTo(x, y, action, delay, sAction, speed, callback, 0);
    }

    public bool MoveTo(
      int x,
      int y,
      string action,
      int delay,
      string sAction,
      int speed,
      LivingCallBack callback,
      int delayCallback)
    {
      if (this.m_x == x && this.m_y == y || x < 0 || x > this.m_map.Bound.Width)
        return false;
      List<Point> path = new List<Point>();
      int num = Living.StepX * 3;
      int stepY = Living.StepY;
      int x1 = this.X;
      int y1 = this.Y;
      int direction = x > x1 ? 1 : -1;
      if (action == "fly")
      {
        Point point1 = new Point(x, y);
        Point point2 = new Point(x1, y1);
        Point point3 = new Point(point1.X - point2.X, point1.Y - point2.Y);
        while (point3.Length() > (double) speed)
        {
          point3.Normalize(speed);
          point2 = new Point(point2.X + point3.X, point2.Y + point3.Y);
          point3 = new Point(point1.X - point2.X, point1.Y - point2.Y);
          if (!(point2 != Point.Empty))
          {
            path.Add(point1);
            break;
          }
          path.Add(point2);
        }
      }
      else
      {
        while ((x - x1) * direction > 0)
        {
          Point nextWalkPoint = this.m_map.FindNextWalkPoint(x1, y1, direction, speed * num, speed * stepY);
          if (nextWalkPoint != Point.Empty)
          {
            path.Add(nextWalkPoint);
            x1 = nextWalkPoint.X;
            y1 = nextWalkPoint.Y;
          }
          else
            break;
        }
      }
      if (path.Count <= 0)
        return false;
      this.m_game.AddAction((IAction) new LivingMoveToAction(this, path, action, delay, speed, sAction, callback, delayCallback));
      return true;
    }

    public Point StartFalling(bool direct) => this.StartFalling(direct, 0, Living.MOVE_SPEED * 10);

    public virtual Point StartFalling(bool direct, int delay, int speed)
    {
      if (this.m_map == null)
        return Point.Empty;
      Point p = this.m_map.FindYLineNotEmptyPoint(this.X, this.Y);
      if (p == Point.Empty)
        p = new Point(this.X, this.m_game.Map.Bound.Height + 1);
      if (p.Y == this.Y)
        return Point.Empty;
      if (direct && this is Player)
      {
        this.SetXY(p);
        if (this.m_map.IsOutMap(p.X, p.Y))
        {
          this.Die();
          if (this.Game.CurrentLiving != this && this.Game.CurrentLiving is Player && this is Player && this.Team != this.Game.CurrentLiving.Team)
          {
            Player currentLiving = this.Game.CurrentLiving as Player;
            currentLiving.PlayerDetail.OnKillingLiving((AbstractGame) this.m_game, 1, this.Id, this.IsLiving, 0);
            ++this.Game.CurrentLiving.TotalKill;
            currentLiving.CalculatePlayerOffer(this as Player);
          }
        }
      }
      else if (!this.Config.IsFly)
        this.m_game.AddAction((IAction) new LivingFallingAction(this, p.X, p.Y, speed, (string) null, delay, 0, (LivingCallBack) null));
      return p;
    }

    public bool FallFrom(int x, int y, string action, int delay, int type, int speed)
    {
      return this.FallFrom(x, y, action, delay, type, speed, (LivingCallBack) null);
    }

    public bool FallFrom(
      int x,
      int y,
      string action,
      int delay,
      int type,
      int speed,
      LivingCallBack callback)
    {
      Point point = this.m_map.FindYLineNotEmptyPoint(x, y);
      if (point == Point.Empty)
        point = new Point(x, this.m_game.Map.Bound.Height + 1);
      if (this.Y >= point.Y)
        return false;
      this.m_game.AddAction((IAction) new LivingFallingAction(this, point.X, point.Y, speed, action, delay, type, callback));
      return true;
    }

    public bool FallFromTo(
      int x,
      int y,
      string action,
      int delay,
      int type,
      int speed,
      LivingCallBack callback)
    {
      this.m_game.AddAction((IAction) new LivingFallingAction(this, x, y, speed, action, delay, type, callback));
      return true;
    }

    public bool JumpTo(int x, int y, string action, int delay, int type)
    {
      return this.JumpTo(x, y, action, delay, type, 20, (LivingCallBack) null);
    }

    public bool JumpTo(int x, int y, string ation, int delay, int type, LivingCallBack callback)
    {
      return this.JumpTo(x, y, ation, delay, type, 20, callback);
    }

    public bool JumpTo(
      int x,
      int y,
      string action,
      int delay,
      int type,
      int speed,
      LivingCallBack callback)
    {
      Point ylineNotEmptyPoint = this.m_map.FindYLineNotEmptyPoint(x, y);
      if (ylineNotEmptyPoint.Y >= this.Y)
        return false;
      this.m_game.AddAction((IAction) new LivingJumpAction(this, ylineNotEmptyPoint.X, ylineNotEmptyPoint.Y, speed, action, delay, type, callback));
      return true;
    }

    public bool JumpToSpeed(
      int x,
      int y,
      string action,
      int delay,
      int type,
      int speed,
      LivingCallBack callback)
    {
      Point ylineNotEmptyPoint = this.m_map.FindYLineNotEmptyPoint(x, y);
      int y1 = ylineNotEmptyPoint.Y;
      this.m_game.AddAction((IAction) new LivingJumpAction(this, ylineNotEmptyPoint.X, ylineNotEmptyPoint.Y, speed, action, delay, type, callback));
      return true;
    }

    public void ChangeDirection(int direction, int delay)
    {
      if (delay > 0)
        this.m_game.AddAction((IAction) new LivingChangeDirectionAction(this, direction, delay));
      else
        this.Direction = direction;
    }

    public double getHertAddition(SqlDataProvider.Data.ItemInfo item)
    {
      if (item == null)
        return 0.0;
      double property7 = (double) item.Template.Property7;
      double strengthenLevel = (double) item.StrengthenLevel;
      return Math.Round(property7 * Math.Pow(1.1, strengthenLevel) - property7) + property7;
    }

    protected int MakeDamage(Living target)
    {
      if (target.Config.IsChristmasBoss)
        return 1;
      double baseDamage = this.BaseDamage;
      double num1 = target.BaseGuard;
      double num2 = target.Defence;
      double attack = this.Attack;
      if (target.AddArmor && (target as Player).DeputyWeapon != null)
      {
        int hertAddition = (int) this.getHertAddition((target as Player).DeputyWeapon);
        num1 += (double) hertAddition;
        num2 += (double) hertAddition;
      }
      if (this.IgnoreArmor)
      {
        num1 = 0.0;
        num2 = 0.0;
      }
      if (this.IgnoreGuard > 0 && !this.IgnoreArmor)
      {
        num1 -= num1 / 100.0 * (double) this.IgnoreGuard;
        num2 -= num2 / 100.0 * (double) this.IgnoreGuard;
      }
      float currentDamagePlus = this.CurrentDamagePlus;
      float currentShootMinus = this.CurrentShootMinus;
      double num3 = 0.95 * (num1 - (double) (3 * this.Grade)) / (500.0 + num1 - (double) (3 * this.Grade));
      double num4 = num2 - this.Lucky >= 0.0 ? 0.95 * (num2 - this.Lucky) / (600.0 + num2 - this.Lucky) : 0.0;
      double num5 = baseDamage * (1.0 + attack * 0.001) * (1.0 - (num3 + num4 - num3 * num4)) * (double) currentDamagePlus * (double) currentShootMinus;
      Point point = new Point(this.X, this.Y);
      return num5 < 0.0 ? 1 : (int) num5;
    }

    public bool Beat(
      Living target,
      string action,
      int demageAmount,
      int criticalAmount,
      int delay,
      int livingCount,
      int attackEffect)
    {
      if (target == null || !target.IsLiving)
        return false;
      demageAmount = this.MakeDamage(target);
      this.OnBeforeTakedDamage(target, ref demageAmount, ref criticalAmount);
      this.StartAttacked();
      if ((int) target.Distance(this.X, this.Y) > this.MaxBeatDis)
        return false;
      this.Direction = this.X - target.X <= 0 ? 1 : -1;
      this.m_game.AddAction((IAction) new LivingBeatAction(this, target, demageAmount, criticalAmount, action, delay, livingCount, attackEffect));
      return true;
    }

    public bool RangeAttacking(int fx, int tx, string action, int delay, List<Player> players)
    {
      if (!this.IsLiving)
        return false;
      this.m_game.AddAction((IAction) new LivingRangeAttackingAction(this, fx, tx, action, delay, players));
      return true;
    }

    public bool RangeAttackingNPC(string action, int delay, List<Living> livings)
    {
      if (!this.IsLiving || livings == null || livings.Count <= 0)
        return false;
      this.m_game.AddAction((IAction) new LivingRangeAttackingNPCAction(this, action, delay, livings));
      return true;
    }

    public void GetShootForceAndAngle(
      ref int x,
      ref int y,
      int bombId,
      int minTime,
      int maxTime,
      int bombCount,
      float time,
      ref int force,
      ref int angle)
    {
      if (minTime >= maxTime)
        return;
      BallInfo ball = BallMgr.FindBall(bombId);
      if (this.m_game == null || ball == null)
        return;
      Map map = this.m_game.Map;
      Point shootPoint = this.GetShootPoint();
      float dx1 = (float) (x - shootPoint.X);
      float dx2 = (float) (y - shootPoint.Y);
      float af = map.airResistance * (float) ball.DragIndex;
      float f1 = map.gravity * (float) ball.Weight * (float) ball.Mass;
      float f2 = map.wind * (float) ball.Wind;
      float mass = (float) ball.Mass;
      for (float t = time; (double) t <= 4.0; t += 0.6f)
      {
        double vx = Living.ComputeVx((double) dx1, mass, af, f2, t);
        double vy = Living.ComputeVy((double) dx2, mass, af, f1, t);
        if (vy < 0.0 && vx * (double) this.m_direction > 0.0)
        {
          double num = Math.Sqrt(vx * vx + vy * vy);
          if (num < 2000.0)
          {
            force = (int) num;
            angle = (int) (Math.Atan(vy / vx) / Math.PI * 180.0);
            if (vx < 0.0)
            {
              angle += 180;
              break;
            }
            break;
          }
        }
      }
      x = shootPoint.X;
      y = shootPoint.Y;
    }

    public bool ShootPoint(
      int x,
      int y,
      int bombId,
      int minTime,
      int maxTime,
      int bombCount,
      float time,
      int delay)
    {
      this.m_game.AddAction((IAction) new LivingShootAction(this, bombId, x, y, 0, 0, bombCount, minTime, maxTime, time, delay));
      return true;
    }

    public bool IsFriendly(Living living) => !(living is Player) && living.Team == this.Team;

    public bool Shoot(int bombId, int x, int y, int force, int angle, int bombCount, int delay)
    {
      this.m_game.AddAction((IAction) new LivingShootAction(this, bombId, x, y, force, angle, bombCount, delay, 0, 0.0f, 0));
      return true;
    }

    public static double ComputeVx(double dx, float m, float af, float f, float t)
    {
      return (dx - (double) f / (double) m * (double) t * (double) t / 2.0) / (double) t + (double) af / (double) m * dx * 0.7;
    }

    public static double ComputeVy(double dx, float m, float af, float f, float t)
    {
      return (dx - (double) f / (double) m * (double) t * (double) t / 2.0) / (double) t + (double) af / (double) m * dx * 1.3;
    }

    public static double ComputDX(double v, float m, float af, float f, float dt)
    {
      return v * (double) dt + ((double) f - (double) af * v) / (double) m * (double) dt * (double) dt;
    }

    public bool ShootImp(
      int bombId,
      int x,
      int y,
      int force,
      int angle,
      int bombCount,
      int shootCount)
    {
      BallInfo ball = BallMgr.FindBall(bombId);
      Tile tile = BallMgr.FindTile(bombId);
      BombType ballType = BallMgr.GetBallType(bombId);
      int num1 = (int) ((double) this.m_map.wind * 10.0);
      if (ball != null)
      {
        GSPacketIn pkg = new GSPacketIn((short) 91, this.Id);
        pkg.Parameter1 = this.Id;
        pkg.WriteByte((byte) 2);
        pkg.WriteInt(num1);
        pkg.WriteBoolean(num1 > 0);
        pkg.WriteByte(this.m_game.GetVane(num1, 1));
        pkg.WriteByte(this.m_game.GetVane(num1, 2));
        pkg.WriteByte(this.m_game.GetVane(num1, 3));
        pkg.WriteInt(bombCount);
        float val1 = 0.0f;
        SimpleBomb simpleBomb = (SimpleBomb) null;
        for (int index = 0; index < bombCount; ++index)
        {
          double num2 = 1.0;
          int num3 = 0;
          switch (index)
          {
            case 1:
              num2 = 0.9;
              num3 = -5;
              break;
            case 2:
              num2 = 1.1;
              num3 = 5;
              break;
          }
          int num4 = (int) ((double) force * num2 * Math.Cos((double) (angle + num3) / 180.0 * Math.PI));
          int num5 = (int) ((double) force * num2 * Math.Sin((double) (angle + num3) / 180.0 * Math.PI));
          SimpleBomb phy = new SimpleBomb(this.m_game.PhysicalId++, ballType, this, this.m_game, ball, tile, this.ControlBall);
          phy.SetXY(x, y);
          phy.setSpeedXY(num4, num5);
          this.m_map.AddPhysical((Physics) phy);
          phy.StartMoving();
          if (index == 0)
            simpleBomb = phy;
          pkg.WriteInt(0);
          pkg.WriteInt(shootCount);
          pkg.WriteBoolean(phy.DigMap);
          pkg.WriteInt(phy.Id);
          pkg.WriteInt(x);
          pkg.WriteInt(y);
          pkg.WriteInt(num4);
          pkg.WriteInt(num5);
          pkg.WriteInt(phy.BallInfo.ID);
          if (this.FlyingPartical != 0)
            pkg.WriteString(this.FlyingPartical.ToString());
          else
            pkg.WriteString(ball.FlyingPartical);
          pkg.WriteInt(phy.BallInfo.Radii * 1000 / 4);
          pkg.WriteInt((int) phy.BallInfo.Power * 1000);
          pkg.WriteInt(phy.Actions.Count);
          foreach (BombAction action in phy.Actions)
          {
            pkg.WriteInt(action.TimeInt);
            pkg.WriteInt(action.Type);
            pkg.WriteInt(action.Param1);
            pkg.WriteInt(action.Param2);
            pkg.WriteInt(action.Param3);
            pkg.WriteInt(action.Param4);
            if (action.Type == 33)
            {
              if (action.Param2 > 0 && action.Param3 > 0)
              {
                this.PassBallFail = true;
                this.m_game.TakePassBall(-1);
              }
              else
                this.m_game.TakePassBall(action.Param1);
            }
          }
          val1 = Math.Max(val1, phy.LifeTime);
        }
        int num6 = 0;
        int count = simpleBomb.PetActions.Count;
        if (count > 0 && this.PetEffects.PetBaseAtt > 0)
        {
          if (simpleBomb.PetActions[0].Type == -1)
          {
            pkg.WriteInt(0);
          }
          else
          {
            pkg.WriteInt(count);
            foreach (BombAction petAction in simpleBomb.PetActions)
            {
              pkg.WriteInt(petAction.Param1);
              pkg.WriteInt(petAction.Param2);
              pkg.WriteInt(petAction.Param4);
              pkg.WriteInt(petAction.Param3);
            }
          }
          num6 = 1500;
          pkg.WriteInt(1);
        }
        else
        {
          pkg.WriteInt(0);
          pkg.WriteInt(0);
        }
        pkg.WriteBoolean(false);
        if (this.m_game.RoomType == eRoomType.FightFootballTime)
        {
          pkg.WriteInt(this.m_game.redScore);
          pkg.WriteInt(this.m_game.blueScore);
          pkg.WriteInt((this as Player).PlayerDetail.PlayerCharacter.ID);
          pkg.WriteInt(0);
          pkg.WriteInt(this.ScoreArr.Count);
          for (int index = 0; index < this.ScoreArr.Count; ++index)
          {
            pkg.WriteInt(0);
            pkg.WriteInt(this.ScoreArr[index]);
          }
        }
        else
        {
          pkg.WriteInt(0);
          pkg.WriteInt(0);
          pkg.WriteInt(0);
          pkg.WriteInt(0);
          pkg.WriteInt(0);
        }
        this.m_game.SendToAll(pkg);
        this.m_game.WaitTime((int) (((double) val1 + 2.0 + (double) (bombCount / 3)) * 1000.0) + num6 + this.PetEffects.PetDelay + this.SpecialSkillDelay);
        if (this.m_game.IsPVE())
          ((PVEGame) this.m_game).method_68();
        return true;
      }
      Console.WriteLine("BallNull {0}", (object) bombId);
      return false;
    }

    public void PlayMovie(string action, int delay, int MovieTime)
    {
      this.m_game.AddAction((IAction) new LivingPlayeMovieAction(this, action, delay, MovieTime));
    }

    public void PlayMovie(string action, int delay, int MovieTime, LivingCallBack call)
    {
      this.m_game.AddAction((IAction) new LivingPlayeMovieAction(this, action, delay, MovieTime));
    }

    public void SetNiutou(bool state)
    {
      if (!this.m_syncAtTime)
        return;
      this.m_game.method_61(this, 33, state);
    }

    public void SetIndian(bool state)
    {
      if (!this.m_syncAtTime)
        return;
      this.m_game.method_61(this, 34, state);
    }

    public void SetTargeting(bool state)
    {
      if (!this.m_syncAtTime)
        return;
      this.m_game.method_61(this, 7, state);
    }

    public void HoldingBall(bool state)
    {
      if (this.bool_7 == state)
        return;
      this.bool_7 = state;
      if (this.m_syncAtTime)
        this.m_game.method_61(this, 99, state);
    }

    public void SetSeal(bool state)
    {
      if (this.bool_6 == state)
        return;
      this.bool_6 = state;
      if (this.m_syncAtTime)
        this.m_game.method_33(this, "silenceMany", state.ToString());
    }

    public void AddRemoveEnergy(int value)
    {
      this.m_game.method_34(this, "energy", value.ToString());
    }

    public void NoFly(bool value)
    {
      if (!this.m_syncAtTime)
        return;
      this.m_game.method_34(this, "nofly", value.ToString());
    }

    public void SetHidden(bool state)
    {
      if (!this.m_syncAtTime)
        return;
      this.m_game.method_33(this, "visible", state.ToString());
    }

    public void SpeedMultX(int value)
    {
      if (!this.m_syncAtTime)
        return;
      this.m_game.method_33(this, "speedX", value.ToString());
    }

    public void SpeedMultY(int value)
    {
      if (!this.m_syncAtTime)
        return;
      this.m_game.method_33(this, "speedY", value.ToString());
    }

    public void OnSmallMap(bool state)
    {
      if (!this.m_syncAtTime)
        return;
      this.m_game.method_33(this, "onSmallMap", state.ToString());
    }

    public bool GetSealState() => this.bool_6;

    public void Seal(Player player, int type, int delay)
    {
      this.m_game.AddAction((IAction) new LivingSealAction(this, player, type, delay));
    }

    public virtual int AddBlood(int value) => this.AddBlood(value, 0);

    public virtual int AddBlood(int value, int type)
    {
      this.m_blood += value;
      if (this.m_blood > this.m_maxBlood)
        this.m_blood = this.m_maxBlood;
      if (this.m_syncAtTime)
        this.m_game.method_28(this, type, value);
      return value;
    }

    public virtual bool TakeDamage(
      Living source,
      ref int damageAmount,
      ref int criticalAmount,
      string msg)
    {
      int num1;
      if (this.Config.IsHelper)
      {
        switch (this)
        {
          case SimpleNpc _:
          case SimpleBoss _:
            num1 = !(source is Player) ? 1 : 0;
            goto label_4;
        }
      }
      num1 = 1;
label_4:
      if (num1 == 0)
        return false;
      bool damage = false;
      if (!this.IsFrost && this.m_blood > 0)
      {
        if (source != this || source.Team == this.Team)
        {
          this.OnBeforeTakedDamage(source, ref damageAmount, ref criticalAmount);
          this.StartAttacked();
        }
        int int_5 = damageAmount + criticalAmount < 0 ? 1 : damageAmount + criticalAmount;
        if (this is Player)
        {
          int reduceDamePlus = (this as Player).PlayerDetail.PlayerCharacter.ReduceDamePlus;
          int num2 = int_5 * reduceDamePlus / 100;
          int_5 -= num2;
        }
        this.m_blood -= int_5;
        int num3 = this.m_maxBlood * 30 / 100;
        if (this is Player && this.m_blood < num3 && this.m_blood > 0 && (this as Player).PlayerDetail.UseKingBlessHelpStraw(this.m_game.RoomType))
        {
          (this as Player).PlayerDetail.SendMessage(LanguageMgr.GetTranslation("Living.Msg1", (object) (this as Player).PlayerDetail.PlayerCharacter.NickName, (object) num3));
          this.AddBlood(num3);
        }
        if (this.m_blood <= 0 && this.Config.KeepLife)
        {
          this.m_blood = 1;
          this.m_game.method_28(this, 1, 1);
        }
        if (this.m_syncAtTime)
        {
          if (this is SimpleBoss && ((SimpleBoss) this).NpcInfo.ID == 0)
            this.m_game.method_28(this, 6, int_5);
          else
            this.m_game.method_28(this, 1, int_5);
        }
        this.OnAfterTakedDamage(source, damageAmount, criticalAmount);
        if (this.m_blood <= 0 && this.m_game.RoomType != eRoomType.FightFootballTime)
        {
          if (criticalAmount > 0 && this is Player)
            this.m_game.AddAction((IAction) new FightAchievementAction(source, 7, source.Direction, 1200));
          this.Die();
        }
        source.OnAfterKillingLiving(this, damageAmount, criticalAmount);
        damage = true;
      }
      this.EffectList.StopEffect(typeof (IceFronzeEffect));
      this.EffectList.StopEffect(typeof (HideEffect));
      this.EffectList.StopEffect(typeof (NoHoleEffect));
      return damage;
    }

    public void SetIceFronze(Living living)
    {
      new IceFronzeEffect(2).Start(this);
      this.BeginNextTurn -= new LivingEventHandle(this.SetIceFronze);
    }

    public virtual bool PetTakeDamage(
      Living source,
      ref int damageAmount,
      ref int criticalAmount,
      string msg)
    {
      if (this.Config.IsHelper && (this is SimpleNpc || this is SimpleBoss))
        return false;
      bool damage = false;
      if (this.m_blood > 0)
      {
        this.m_blood -= damageAmount + criticalAmount;
        if (this.m_blood <= 0)
        {
          if (this.Config.KeepLife)
            this.m_blood = 1;
          else
            this.Die();
        }
        damage = true;
      }
      return damage;
    }

    public virtual void Die(int delay)
    {
      if (!this.IsLiving || this.m_game == null)
        return;
      this.m_game.AddAction((IAction) new LivingDieAction(this, delay));
    }

    public override void Die()
    {
      if (this.m_blood > 0)
      {
        this.m_blood = 0;
        this.int_2 = -1;
        if (this.m_syncAtTime)
          this.m_game.method_28(this, 6, 0);
      }
      if (!this.IsLiving)
        return;
      if (this.IsAttacking)
        this.StopAttacking();
      base.Die();
      this.OnDied();
      this.m_game.CheckState(0);
    }

    public override void Revive() => base.Revive();

    protected void OnDied()
    {
      if (this.livingEventHandle_0 != null)
        this.livingEventHandle_0(this);
      if (!(this is Player) || !(this.Game is PVEGame))
        return;
      ((PVEGame) this.Game).DoOther();
    }

    protected void OnBeforeTakedDamage(Living source, ref int damageAmount, ref int criticalAmount)
    {
      if (this.livingTakedDamageEventHandle_0 == null)
        return;
      this.livingTakedDamageEventHandle_0(this, source, ref damageAmount, ref criticalAmount);
    }

    public void OnTakedDamage(Living source, ref int damageAmount, ref int criticalAmount)
    {
      if (this.livingTakedDamageEventHandle_1 == null)
        return;
      this.livingTakedDamageEventHandle_1(this, source, ref damageAmount, ref criticalAmount);
    }

    protected void OnBeginNewTurn()
    {
      if (this.livingEventHandle_1 == null)
        return;
      this.livingEventHandle_1(this);
    }

    protected void OnBeginSelfTurn()
    {
      if (this.livingEventHandle_2 == null)
        return;
      this.livingEventHandle_2(this);
    }

    protected void OnStartAttacked()
    {
      if (this.livingEventHandle_4 == null)
        return;
      this.livingEventHandle_4(this);
    }

    protected void OnStartAttacking()
    {
      if (this.livingEventHandle_3 == null)
        return;
      this.livingEventHandle_3(this);
    }

    protected void OnStopAttacking()
    {
      if (this.livingEventHandle_5 == null)
        return;
      this.livingEventHandle_5(this);
    }

    public virtual void OnAfterKillingLiving(Living target, int damageAmount, int criticalAmount)
    {
      if (target.Team != this.Team)
      {
        this.CurrentIsHitTarget = true;
        this.TotalHurt += damageAmount + criticalAmount;
        if (!target.IsLiving)
          ++this.TotalKill;
        this.m_game.CurrentTurnTotalDamage = damageAmount + criticalAmount;
        this.m_game.TotalHurt += damageAmount + criticalAmount;
      }
      if (this.killLivingEventHanlde_0 == null)
        return;
      this.killLivingEventHanlde_0(this, target, damageAmount, criticalAmount);
    }

    public void OnAfterTakedDamage(Living target, int damageAmount, int criticalAmount)
    {
      if (this.killLivingEventHanlde_1 == null)
        return;
      this.killLivingEventHanlde_1(this, target, damageAmount, criticalAmount);
    }

    public void CallFuction(LivingCallBack func, int delay)
    {
      if (this.m_game == null)
        return;
      this.m_game.AddAction((IAction) new LivingCallFunctionAction(this, func, delay));
    }
  }
}
