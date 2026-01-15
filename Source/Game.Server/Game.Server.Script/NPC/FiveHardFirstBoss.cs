// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.NPC.FiveHardFirstBoss
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic;
using Game.Logic.AI;
using Game.Logic.Effects;
using Game.Logic.Phy.Object;
using System.Collections.Generic;

#nullable disable
namespace GameServerScript.AI.NPC
{
  public class FiveHardFirstBoss : ABrain
  {
    private int m_attackTurn = 0;
    private PhysicalObj m_moive;
    private PhysicalObj m_wallRight = (PhysicalObj) null;
    private static string[] AllAttackChat = new string[3]
    {
      "要地震喽！！<br/>各位请扶好哦",
      "把你武器震下来！",
      "看你们能还经得起几下！！"
    };
    private static string[] ShootChat = new string[3]
    {
      "让你知道什么叫百发百中！",
      "送你一个球~你可要接好啦",
      "你们这群无知的低等庶民"
    };
    private static string[] ShootedChat = new string[2]
    {
      "哎呀~~你们为什么要攻击我？<br/>我在干什么？",
      "噢~~好痛!我为什么要战斗？<br/>我必须战斗…"
    };
    private static string[] AddBooldChat = new string[3]
    {
      "扭啊扭~<br/>扭啊扭~~",
      "哈利路亚~<br/>路亚路亚~~",
      "呀呀呀，<br/>好舒服啊！"
    };
    private static string[] KillAttackChat = new string[1]
    {
      "君临天下！！"
    };

    public override void OnBeginSelfTurn() => base.OnBeginSelfTurn();

    public override void OnBeginNewTurn()
    {
      base.OnBeginNewTurn();
      this.m_body.CurrentDamagePlus = 1f;
      this.m_body.CurrentShootMinus = 1f;
    }

    public override void OnCreated() => base.OnCreated();

    public override void OnStartAttacking()
    {
      base.OnStartAttacking();
      bool flag = false;
      int num1 = 0;
      foreach (Player allFightPlayer in this.Game.GetAllFightPlayers())
      {
        if (allFightPlayer.IsLiving && allFightPlayer.X > 0 && allFightPlayer.X < 0)
        {
          int num2 = (int) this.Body.Distance(allFightPlayer.X, allFightPlayer.Y);
          if (num2 > num1)
            num1 = num2;
          flag = true;
        }
      }
      if (flag)
        this.KillAttack(1400, 1600);
      else if (this.m_attackTurn == 0)
      {
        this.BeatA();
        this.Body.SetXY(this.Body.X, 659);
        ++this.m_attackTurn;
      }
      else if (this.m_attackTurn == 1)
      {
        this.Body.SetXY(this.Body.X, 559);
        this.BeatB();
        ++this.m_attackTurn;
      }
      else if (this.m_attackTurn == 2)
      {
        this.Body.SetXY(this.Body.X, 459);
        this.BeatC();
        ++this.m_attackTurn;
      }
      else if (this.m_attackTurn == 3)
      {
        this.Body.SetXY(this.Body.X, 359);
        this.BeatD();
        ++this.m_attackTurn;
      }
      else if (this.m_attackTurn == 4)
      {
        if (this.Body.Y == 758)
        {
          this.m_attackTurn = 0;
        }
        else
        {
          this.BeatE();
          this.Body.SetXY(this.Body.X, 259);
          ++this.m_attackTurn;
        }
      }
      else
      {
        if (this.m_attackTurn != 5)
          return;
        if (this.Body.Y == 758)
        {
          this.m_attackTurn = 0;
        }
        else
        {
          this.BeatG();
          this.Body.SetXY(this.Body.X, 259);
        }
      }
    }

    public override void OnStopAttacking() => base.OnStopAttacking();

    private void KillAttack(int fx, int tx)
    {
      int index = this.Game.Random.Next(0, FiveHardFirstBoss.KillAttackChat.Length);
      this.Body.Say(FiveHardFirstBoss.KillAttackChat[index], 1, 1000);
      this.Body.CurrentDamagePlus = 10f;
      this.Body.PlayMovie("beat", 3000, 10000);
      this.Body.RangeAttacking(fx, tx, "cry", 5000, (List<Player>) null);
    }

    private void BeatA()
    {
      this.Body.PlayMovie("beatA", 3000, 11000);
      this.Body.CallFuction(new LivingCallBack(this.CallBeatA), 11000);
    }

    private void CallBeatA()
    {
      this.Body.PlayMovie("standA", 2000, 0);
      List<Player> allLivingPlayers = this.Game.GetAllLivingPlayers();
      int blood = this.Game.Random.Next(1000, 2510);
      foreach (Player liv in allLivingPlayers)
        liv.AddEffect((AbstractEffect) new ContinueReduceBloodEffect(2, blood, (Living) liv), 0);
    }

    private void BeatB()
    {
      this.Body.PlayMovie("beatB", 3000, 10000);
      Player randomPlayer = this.Game.FindRandomPlayer();
      ((SimpleBoss) this.Body).NpcInfo.FireY = 0;
      if (randomPlayer != null)
        this.Body.ShootPoint(randomPlayer.X, randomPlayer.Y, 56, 1000, 10000, 1, 2f, 10000);
      this.Body.CallFuction(new LivingCallBack(this.CallBeatB), 11000);
    }

    private void CallBeatB() => this.Body.PlayMovie("standB", 3000, 0);

    private void BeatC()
    {
      this.Body.PlayMovie("beatC", 3000, 10000);
      this.Body.CallFuction(new LivingCallBack(this.CallBeatC), 11000);
    }

    private void CallBeatC()
    {
      this.Body.PlayMovie("standC", 3000, 0);
      List<Player> allFightPlayers = this.Game.GetAllFightPlayers();
      foreach (Player player in allFightPlayers)
      {
        int num = this.Game.Random.Next(200, 510);
        this.m_wallRight = ((PVEGame) this.Game).CreatePhysicalObj(player.X, player.Y, "wallLeft", "asset.game.4.zap", "1", 1, 1);
        player.AddEffect((AbstractEffect) new ReduceStrengthEffect(2, 5), 0);
        player.AddBlood(-num, 1);
      }
      List<Player> playerList = new List<Player>();
      foreach (Player player in allFightPlayers)
      {
        if (!player.IsFrost)
          playerList.Add(player);
      }
    }

    private void BeatD()
    {
      this.Body.PlayMovie("beatD", 3000, 10000);
      this.Body.CallFuction(new LivingCallBack(this.CallBeatD), 11000);
    }

    private void CallBeatD()
    {
      this.Body.PlayMovie("standD", 3000, 0);
      foreach (Player allFightPlayer in this.Game.GetAllFightPlayers())
      {
        int num = this.Game.Random.Next(100, 515);
        this.m_moive = (PhysicalObj) ((PVEGame) this.Game).Createlayer(allFightPlayer.X, allFightPlayer.Y, "moive", "asset.game.4.minigun", "", 1, 1);
        allFightPlayer.AddBlood(-num, 1);
        allFightPlayer.AddBlood(-num, 1);
        allFightPlayer.AddBlood(-num, 1);
        allFightPlayer.AddBlood(-num, 1);
        allFightPlayer.AddBlood(-num, 1);
        allFightPlayer.AddBlood(-num, 1);
      }
    }

    private void BeatE()
    {
      this.Body.PlayMovie("DtoE", 3000, 10000);
      this.Body.CallFuction(new LivingCallBack(this.BeatG), 10000);
    }

    private void CallBeatE() => this.Body.PlayMovie("standE", 3000, 0);

    private void BeatG()
    {
      Player randomPlayer = this.Game.FindRandomPlayer();
      this.Body.PlayMovie("beatE", 3000, 10000);
      ((SimpleBoss) this.Body).NpcInfo.FireY = 20;
      this.Body.ShootPoint(randomPlayer.X, randomPlayer.Y, 72, 1000, 10000, 1, 1f, 5500);
      this.Body.CallFuction(new LivingCallBack(this.CallBeatE), 10000);
    }
  }
}
