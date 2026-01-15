// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.NPC.FiveHardFirstNpc
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic.AI;
using Game.Logic.Phy.Object;
using System.Collections.Generic;

#nullable disable
namespace GameServerScript.AI.NPC
{
  public class FiveHardFirstNpc : ABrain
  {
    private int m_attackTurn = 0;
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
      this.Body.Direction = this.Game.FindlivingbyDir(this.Body);
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
        this.KillAttack(0, 0);
      else if (this.m_attackTurn == 0)
      {
        this.Walk();
        ++this.m_attackTurn;
      }
      else if (this.m_attackTurn == 1)
      {
        this.Walk();
        ++this.m_attackTurn;
      }
      else if (this.m_attackTurn == 2)
      {
        this.Walk();
        ++this.m_attackTurn;
      }
      else if (this.m_attackTurn == 3)
      {
        this.Walk();
        ++this.m_attackTurn;
      }
      else if (this.m_attackTurn == 4)
      {
        this.Ato();
        ++this.m_attackTurn;
      }
      else
        this.Stand();
    }

    public override void OnStopAttacking() => base.OnStopAttacking();

    private void KillAttack(int fx, int tx)
    {
      int index = this.Game.Random.Next(0, FiveHardFirstNpc.KillAttackChat.Length);
      this.Body.Say(FiveHardFirstNpc.KillAttackChat[index], 1, 1000);
      this.Body.CurrentDamagePlus = 10f;
      this.Body.PlayMovie("beat", 3000, 0);
      this.Body.RangeAttacking(fx, tx, "cry", 5000, (List<Player>) null);
    }

    private void Walk() => this.Body.PlayMovie("walkA", 3000, 1000);

    private void Stand() => this.Body.PlayMovie("standA", 3000, 1000);

    private void Ato()
    {
      this.Body.PlayMovie("AtoB", 3000, 5000);
      this.Body.CallFuction(new LivingCallBack(this.WalkB), 2000);
    }

    private void WalkB() => this.Body.PlayMovie("walkB", 3000, 2000);
  }
}
