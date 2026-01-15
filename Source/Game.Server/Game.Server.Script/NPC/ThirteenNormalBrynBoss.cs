// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.NPC.ThirteenNormalBrynBoss
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Bussiness;
using Game.Logic;
using Game.Logic.AI;
using Game.Logic.Effects;
using Game.Logic.Phy.Object;
using System.Collections.Generic;

#nullable disable
namespace GameServerScript.AI.NPC
{
  public class ThirteenNormalBrynBoss : ABrain
  {
    private int m_attackTurn = 0;
    private PhysicalObj m_npc;
    private PhysicalObj m_moive;
    private int isSay = 0;
    private static string[] AllAttackChat = new string[3]
    {
      LanguageMgr.GetTranslation("Sư tử rống..."),
      LanguageMgr.GetTranslation("Sức mạnh của chúa rừng !"),
      LanguageMgr.GetTranslation("Sự đau đớn tột độ !")
    };
    private static string[] ShootChat = new string[2]
    {
      LanguageMgr.GetTranslation("Nén đá dấu tay ...!"),
      LanguageMgr.GetTranslation("Vũ khí của thần bộ lạc !")
    };
    private static string[] KillPlayerChat = new string[2]
    {
      LanguageMgr.GetTranslation("GameServerScript.AI.NPC.SimpleQueenAntAi.msg6"),
      LanguageMgr.GetTranslation("GameServerScript.AI.NPC.SimpleQueenAntAi.msg7")
    };
    private static string[] CallChat = new string[2]
    {
      LanguageMgr.GetTranslation("Vật tổ ..."),
      LanguageMgr.GetTranslation("Kill !")
    };
    private static string[] JumpChat = new string[3]
    {
      LanguageMgr.GetTranslation("GameServerScript.AI.NPC.SimpleQueenAntAi.msg10"),
      LanguageMgr.GetTranslation("GameServerScript.AI.NPC.SimpleQueenAntAi.msg11"),
      LanguageMgr.GetTranslation("GameServerScript.AI.NPC.SimpleQueenAntAi.msg12")
    };
    private static string[] KillAttackChat = new string[2]
    {
      LanguageMgr.GetTranslation("GameServerScript.AI.NPC.SimpleQueenAntAi.msg13"),
      LanguageMgr.GetTranslation("GameServerScript.AI.NPC.SimpleQueenAntAi.msg14")
    };
    private static string[] ShootedChat = new string[2]
    {
      LanguageMgr.GetTranslation("GameServerScript.AI.NPC.SimpleQueenAntAi.msg15"),
      LanguageMgr.GetTranslation("GameServerScript.AI.NPC.SimpleQueenAntAi.msg16")
    };
    private static string[] DiedChat = new string[1]
    {
      LanguageMgr.GetTranslation("GameServerScript.AI.NPC.SimpleQueenAntAi.msg17")
    };

    public override void OnBeginSelfTurn() => base.OnBeginSelfTurn();

    public override void OnBeginNewTurn()
    {
      base.OnBeginNewTurn();
      this.Body.CurrentDamagePlus = 1f;
      this.Body.CurrentShootMinus = 1f;
      this.isSay = 0;
    }

    public override void OnCreated() => base.OnCreated();

    public override void OnStartAttacking()
    {
      this.Body.Direction = this.Game.FindlivingbyDir(this.Body);
      bool flag = false;
      int num1 = 0;
      foreach (Player allFightPlayer in this.Game.GetAllFightPlayers())
      {
        if (allFightPlayer.IsLiving && allFightPlayer.X > 950 && allFightPlayer.X < 1250 && allFightPlayer.Y > 666)
        {
          int num2 = (int) this.Body.Distance(allFightPlayer.X, allFightPlayer.Y);
          if (num2 > num1)
            num1 = num2;
          flag = true;
        }
      }
      if (flag)
        this.KillAttack(950, 1250);
      else if (this.m_attackTurn == 0)
      {
        this.SummonA();
        ++this.m_attackTurn;
      }
      else if (this.m_attackTurn == 1)
      {
        this.CreateMovie();
        ++this.m_attackTurn;
      }
      else if (this.m_attackTurn == 2)
      {
        this.PersonalAttack();
        ++this.m_attackTurn;
      }
      else
      {
        this.PersonalAttack2();
        this.m_attackTurn = 0;
      }
    }

    public override void OnStopAttacking() => base.OnStopAttacking();

    private void KillAttack(int fx, int tx)
    {
      int index = this.Game.Random.Next(0, ThirteenNormalBrynBoss.KillAttackChat.Length);
      this.Body.Say(ThirteenNormalBrynBoss.KillAttackChat[index], 1, 1000);
      this.Body.CurrentDamagePlus = 20f;
      this.Body.PlayMovie("beatC", 3000, 0);
      this.Body.RangeAttacking(fx, tx, "cry", 5000, (List<Player>) null);
    }

    private void PersonalAttack()
    {
      this.m_moive.PlayMovie("beatA", 1000, 1000);
      this.Body.CallFuction(new LivingCallBack(this.CallEffectB), 1000);
    }

    private void CallEffectB()
    {
      bool flag = false;
      Player[] allPlayers = this.Game.GetAllPlayers();
      List<Player> players = new List<Player>();
      foreach (Player player in allPlayers)
      {
        if (player.X > 990 && player.X < 1315 && player.Y < 606)
        {
          flag = true;
          players.Add(player);
          break;
        }
      }
      if (flag)
      {
        foreach (Player player in allPlayers)
        {
          player.AddEffect((AbstractEffect) new DamageEffect(2), 0);
          player.AddEffect((AbstractEffect) new GuardEffect(2), 0);
        }
      }
      this.Body.RangeAttacking(this.Body.X - 1500, this.Body.X + 1500, "cry", 1500, players);
    }

    private void PersonalAttack2()
    {
      int index = this.Game.Random.Next(0, ThirteenNormalBrynBoss.ShootChat.Length);
      this.Body.Say(ThirteenNormalBrynBoss.ShootChat[index], 1, 0);
      this.Body.CallFuction(new LivingCallBack(this.DoudbleAttack), 2600);
      this.Body.CallFuction(new LivingCallBack(this.DoudbleAttack), 6500);
    }

    private void DoudbleAttack()
    {
      Player randomPlayer = this.Game.FindRandomPlayer();
      this.Body.CurrentDamagePlus = 1.8f;
      if (randomPlayer == null)
        return;
      this.Game.Random.Next(randomPlayer.X - 10, randomPlayer.X + 10);
      if (this.Body.ShootPoint(randomPlayer.X, randomPlayer.Y, 55, 1000, 10000, 1, 1.5f, 2550))
        this.Body.PlayMovie("beatB", 1700, 0);
    }

    private void SummonA()
    {
      this.Body.PlayMovie("callA", 3500, 0);
      this.Body.RangeAttacking(this.Body.X - 1500, this.Body.X + 1500, "cry", 5500, (List<Player>) null);
      this.Body.CallFuction(new LivingCallBack(this.GoMovie), 5500);
      this.Body.CallFuction(new LivingCallBack(this.MovingPlayer), 6500);
    }

    private void MovingPlayer()
    {
      foreach (Player allPlayer in this.Game.GetAllPlayers())
      {
        int x = this.Game.Random.Next(900, 1350);
        allPlayer.StartSpeedMult(x, allPlayer.Y);
      }
    }

    private void GoMovie()
    {
      foreach (Player allFightPlayer in this.Game.GetAllFightPlayers())
        ((PVEGame) this.Game).Createlayer(allFightPlayer.X, allFightPlayer.Y, "boom", "game.living.Living126", "beatA", 1, 0);
    }

    public void CreateMovie()
    {
      this.m_moive = ((PVEGame) this.Game).CreatePhysicalObj(1146, 566, "moiveA", "asset.game.ten.jitan", "born", 1, 0);
      this.Body.CallFuction(new LivingCallBack(this.SummonB), 1000);
    }

    private void SummonB()
    {
      this.Body.PlayMovie("callA", 3500, 0);
      this.Body.RangeAttacking(this.Body.X - 1500, this.Body.X + 1500, "cry", 5500, (List<Player>) null);
      this.Body.CallFuction(new LivingCallBack(this.GoMovie), 5500);
      this.Body.CallFuction(new LivingCallBack(this.CallEffectA), 6500);
    }

    private void CallEffectA()
    {
      List<Player> allLivingPlayers = this.Game.GetAllLivingPlayers();
      int num = 0;
      foreach (Player player in allLivingPlayers)
      {
        if (num == 0)
          player.AddEffect((AbstractEffect) new ReduceStrengthEffect(3, 110), 0);
        if (num == 1)
          player.AddEffect((AbstractEffect) new LockDirectionEffect(3), 0);
        ++num;
      }
    }

    public override void OnKillPlayerSay()
    {
      base.OnKillPlayerSay();
      int index = this.Game.Random.Next(0, ThirteenNormalBrynBoss.KillPlayerChat.Length);
      this.Body.Say(ThirteenNormalBrynBoss.KillPlayerChat[index], 1, 0, 2000);
    }

    public override void OnShootedSay()
    {
      int index1 = this.Game.Random.Next(0, ThirteenNormalBrynBoss.ShootedChat.Length);
      if (this.isSay == 0 && this.Body.IsLiving)
      {
        this.Body.Say(ThirteenNormalBrynBoss.ShootedChat[index1], 1, 900, 0);
        this.isSay = 1;
      }
      if (this.Body.IsLiving)
        return;
      int index2 = this.Game.Random.Next(0, ThirteenNormalBrynBoss.DiedChat.Length);
      this.Body.Say(ThirteenNormalBrynBoss.DiedChat[index2], 1, 100, 2000);
    }
  }
}
