import React, {
  useEffect,
  useMemo,
  useRef,
  useState,
  createContext,
  useContext,
} from "react";
import { motion, AnimatePresence } from "framer-motion";
import {
  ArrowLeft,
  ArrowRight,
  Upload,
  Mic,
  Sparkles,
  ShieldCheck,
  Zap,
  Crown,
  CheckCircle2,
  AlertTriangle,
  Timer,
  BarChart3,
  Lock,
  Layers,
  MessageSquareText,
} from "lucide-react";

/**
 * The Briefing Master — High-Fidelity Mobile Prototype (React)
 * - Single-file demo for browser validation
 * - Feature-first structure simulated through components
 * - Tailwind classes + Framer Motion transitions
 */

// ───────────────────────────────────────────────────────────────────────────────
// THEME TOKENS (Flutter-ready mapping)
// ───────────────────────────────────────────────────────────────────────────────
const theme = {
  font: {
    family:
      "Inter, ui-sans-serif, system-ui, -apple-system, Segoe UI, Roboto, Helvetica, Arial",
  },
  radius: {
    sm: "rounded-xl",
    md: "rounded-2xl",
    lg: "rounded-3xl",
  },
  shadow: {
    card: "shadow-[0_10px_30px_rgba(0,0,0,0.22)]",
    soft: "shadow-[0_10px_30px_rgba(0,0,0,0.12)]",
  },
  modes: {
    deepWork: {
      name: "Deep Work",
      badge: "bg-zinc-800 text-zinc-100",
      glow: "from-white/10 via-white/5 to-transparent",
    },
    adrenaline: {
      name: "Adrenaline",
      badge: "bg-rose-500/15 text-rose-100",
      glow: "from-rose-400/20 via-amber-400/10 to-transparent",
    },
    focus: {
      name: "Focus",
      badge: "bg-indigo-500/15 text-indigo-100",
      glow: "from-indigo-400/20 via-cyan-400/10 to-transparent",
    },
  },
};

// ───────────────────────────────────────────────────────────────────────────────
// APP STATE (Riverpod-like reactive derived state simulation)
// ───────────────────────────────────────────────────────────────────────────────
const AppContext = createContext(null);

const useApp = () => {
  const ctx = useContext(AppContext);
  if (!ctx) throw new Error("AppContext missing");
  return ctx;
};

const ROUTES = {
  Welcome: "welcome",
  Onboarding: "onboarding",
  Upload: "upload",
  Priming: "priming",
  Speaking: "speaking",
  Quiz: "quiz",
  Revision: "revision",
  Paywall: "paywall",
  Premium: "premium",
};

// Route → subtle color aura (each learning sub-module has a dominant color)
const routeAccents = {
  [ROUTES.Welcome]: "from-cyan-400/25 via-indigo-400/10 to-transparent",
  [ROUTES.Onboarding]: "from-cyan-400/20 via-white/5 to-transparent",
  [ROUTES.Upload]: "from-cyan-400/25 via-indigo-400/10 to-transparent",
  [ROUTES.Priming]: "from-cyan-400/25 via-transparent to-transparent",
  [ROUTES.Speaking]: "from-rose-400/25 via-amber-400/10 to-transparent",
  [ROUTES.Quiz]: "from-indigo-400/25 via-cyan-400/10 to-transparent",
  [ROUTES.Revision]: "from-emerald-400/25 via-transparent to-transparent",
  [ROUTES.Paywall]: "from-amber-400/25 via-transparent to-transparent",
  [ROUTES.Premium]: "from-amber-300/25 via-cyan-300/10 to-transparent",
};

// Accent-Line (Option A): subtle “alive” colored line that changes per module
const routeAccentLines = {
  [ROUTES.Welcome]: "from-cyan-500/80 via-indigo-500/50 to-transparent",
  [ROUTES.Onboarding]: "from-cyan-500/70 via-sky-400/40 to-transparent",
  [ROUTES.Upload]: "from-cyan-500/80 via-indigo-500/50 to-transparent",
  [ROUTES.Priming]: "from-cyan-500/80 via-transparent to-transparent",
  [ROUTES.Speaking]: "from-rose-500/80 via-amber-500/50 to-transparent",
  [ROUTES.Quiz]: "from-indigo-500/80 via-cyan-500/50 to-transparent",
  [ROUTES.Revision]: "from-emerald-500/80 via-teal-400/45 to-transparent",
  [ROUTES.Paywall]: "from-amber-500/80 via-orange-400/45 to-transparent",
  [ROUTES.Premium]: "from-amber-400/80 via-cyan-400/45 to-transparent",
};

const fallbackAccent = "from-white/10 via-white/5 to-transparent";

const defaultProfile = {
  hydrated: false,
  role: "Support N2",
  company: "Northstar Systems",
  dashboardMetric: "Q3 revenue down 20%",
  target: "Sound like an Executive in crisis calls",
  language: "English",
};

const baseScenario = {
  id: "crisis-briefing",
  title: "Crisis Meeting: Revenue Drop",
  description:
    "You must brief leadership on the situation, propose a root-cause path, and commit to a recovery plan — under pressure.",
  intent: "Reporting bad news + proposing a plan",
};

// Semantic content pool (mocked)
const semanticPools = {
  "Reporting a delay": {
    tier1: ["We are late.", "It will take more time.", "I am checking it."],
    tier2: [
      "We’re experiencing a delay due to dependencies.",
      "I’m actively investigating the cause.",
      "I’ll share an updated ETA shortly.",
    ],
    tier3: [
      "We’ve identified the bottleneck and are executing a mitigation plan.",
      "I’m investigating the root cause and will confirm the corrective actions.",
      "You’ll have a revised timeline and risk assessment within the hour.",
    ],
    connectors: ["However", "Therefore", "As a result", "To de-risk this"],
    powerVerbs: ["stabilize", "mitigate", "validate", "escalate", "unblock"],
  },
  "Sharing bad news": {
    tier1: ["We have a problem.", "It’s not good.", "Sales are down."],
    tier2: [
      "We’ve seen a negative variance this quarter.",
      "The trend is below forecast.",
      "We need to address the drivers quickly.",
    ],
    tier3: [
      "We’re facing a material shortfall versus forecast, and we’re already executing a recovery plan.",
      "I’ll walk you through the drivers, our mitigation strategy, and the expected impact timeline.",
      "Our priority is to stabilize performance while preserving customer trust.",
    ],
    connectors: ["First", "Second", "Net-net", "Here’s the upside"],
    powerVerbs: ["quantify", "triage", "stabilize", "accelerate", "align"],
  },
};

function clamp(n, a, b) {
  return Math.max(a, Math.min(b, n));
}

function pick(arr) {
  return arr[Math.floor(Math.random() * arr.length)];
}

function computeSophisticationScore(text) {
  const t = String(text || "").toLowerCase();
  let score = 42;

  // Penalize filler words / hesitation
  const filler = ["uh", "um", "like", "you know", "basically", "sort of", "kinda"];
  const fillerHits = filler.reduce((acc, w) => acc + (t.includes(w) ? 1 : 0), 0);
  score -= fillerHits * 6;

  // Reward executive connectors / verbs
  const rewards = [
    "root cause",
    "mitigation",
    "risk",
    "stabilize",
    "timeline",
    "impact",
    "therefore",
    "as a result",
    "net-net",
    "corrective",
  ];
  const rewardHits = rewards.reduce((acc, w) => acc + (t.includes(w) ? 1 : 0), 0);
  score += rewardHits * 7;

  // Reward structure cues
  const structure = [
    "first",
    "second",
    "third",
    "to summarize",
    "in short",
    "my recommendation",
  ];
  const structureHits = structure.reduce((acc, w) => acc + (t.includes(w) ? 1 : 0), 0);
  score += structureHits * 5;

  // Short / long extremes
  if (String(text || "").trim().length < 40) score -= 7;
  if (String(text || "").trim().length > 240) score -= 4;

  return clamp(Math.round(score), 0, 100);
}

function detectIntentCluster(text) {
  const t = String(text || "").toLowerCase();
  if (t.includes("delay") || t.includes("eta") || t.includes("blocked")) return "Reporting a delay";
  if (
    t.includes("revenue") ||
    t.includes("down") ||
    t.includes("variance") ||
    t.includes("forecast") ||
    t.includes("shortfall")
  ) {
    return "Sharing bad news";
  }
  return "Sharing bad news";
}

function generateTierUpgrade(text, cluster) {
  const pool = semanticPools[cluster] ?? semanticPools["Sharing bad news"];
  const tier2 = pick(pool.tier2);
  const tier3 = pick(pool.tier3);
  return {
    tier2,
    tier3,
    rationale: `Upgrade via executive structure + measurable commitments. Add connectors like “${pick(
      pool.connectors
    )}” and a power verb like “${pick(pool.powerVerbs)}”.`,
  };
}

// ───────────────────────────────────────────────────────────────────────────────
// MOCK REALTIME COACHING STREAM (simulated WebSocket)
// ───────────────────────────────────────────────────────────────────────────────
function useMockCoachStream(isActive, onMessage, profile) {
  const intervalRef = useRef(null);

  useEffect(() => {
    if (!isActive) {
      if (intervalRef.current) clearInterval(intervalRef.current);
      intervalRef.current = null;
      return;
    }

    const tips = [
      {
        type: "tip",
        title: "Executive Polish",
        body: "Commit to a timeline. Replace ‘soon’ with a measurable ETA.",
      },
      {
        type: "tip",
        title: "Structure",
        body: "Use PREP: Point → Reason → Example → Point. Keep it crisp.",
      },
      {
        type: "warn",
        title: "Hesitation Detected",
        body: "You paused twice. Slow down and anchor with a connector: ‘Therefore…’",
      },
      {
        type: "tip",
        title: "Leadership Tone",
        body: "Own the narrative: ‘We identified the driver, and we’re mitigating it now.’",
      },
      {
        type: "tip",
        title: "Data Authority",
        body: `Reference the metric: “${profile.dashboardMetric}” — then propose the recovery plan.`,
      },
    ];

    intervalRef.current = setInterval(() => {
      onMessage({
        id: `${Date.now()}-${Math.random().toString(16).slice(2)}`,
        ...pick(tips),
        ts: Date.now(),
      });
    }, 1900);

    return () => {
      if (intervalRef.current) clearInterval(intervalRef.current);
      intervalRef.current = null;
    };
  }, [isActive, onMessage, profile.dashboardMetric]);
}

// ───────────────────────────────────────────────────────────────────────────────
// SHARED UI
// ───────────────────────────────────────────────────────────────────────────────
function Pill({ icon: Icon, label, variant = "muted" }) {
  const styles =
    variant === "success"
      ? "bg-emerald-500/10 text-emerald-900/90 dark:text-emerald-100 border-emerald-500/20"
      : variant === "warn"
      ? "bg-amber-500/10 text-amber-900/90 dark:text-amber-100 border-amber-500/20"
      : variant === "danger"
      ? "bg-rose-500/10 text-rose-900/90 dark:text-rose-100 border-rose-500/20"
      : "bg-black/5 dark:bg-white/6 text-zinc-900/85 dark:text-zinc-100 border-black/10 dark:border-white/10";

  return (
    <div
      className={`inline-flex items-center gap-2 px-3 py-1.5 border ${styles} rounded-full text-[12px]`}
    >
      {Icon ? <Icon size={14} className="opacity-90" /> : null}
      <span className="leading-none">{label}</span>
    </div>
  );
}

function PrimaryButton({ children, onClick, icon: Icon, disabled }) {
  return (
    <button
      onClick={onClick}
      disabled={disabled}
      className={`w-full inline-flex items-center justify-center gap-2 px-4 py-3 rounded-2xl font-semibold transition active:scale-[0.99]
      ${
        disabled
          ? "bg-black/10 text-zinc-600 dark:bg-white/10 dark:text-white/50"
          : "bg-zinc-950 text-white hover:bg-zinc-900 dark:bg-white dark:text-zinc-950 dark:hover:bg-white/90"
      }`}
    >
      {Icon ? <Icon size={18} /> : null}
      {children}
    </button>
  );
}

function SecondaryButton({ children, onClick, icon: Icon }) {
  return (
    <button
      onClick={onClick}
      className="w-full inline-flex items-center justify-center gap-2 px-4 py-3 rounded-2xl font-semibold transition active:scale-[0.99] bg-black/5 dark:bg-white/10 text-zinc-950 dark:text-white hover:bg-black/10 dark:hover:bg-white/14 border border-black/10 dark:border-white/10"
    >
      {Icon ? <Icon size={18} className="opacity-90" /> : null}
      {children}
    </button>
  );
}

function ProgressBar({ value }) {
  return (
    <div className="w-full h-2 bg-black/10 dark:bg-white/10 rounded-full overflow-hidden">
      <div
        className="h-full bg-zinc-950/80 dark:bg-white/70"
        style={{ width: `${clamp(value, 0, 100)}%` }}
      />
    </div>
  );
}

function ToastStack({ items, onClear }) {
  return (
    <div className="absolute left-3 right-3 top-14 z-50 pointer-events-none">
      <AnimatePresence initial={false}>
        {items.slice(0, 3).map((t) => (
          <motion.div
            key={t.id}
            initial={{ y: -10, opacity: 0, scale: 0.98 }}
            animate={{ y: 0, opacity: 1, scale: 1 }}
            exit={{ y: -10, opacity: 0, scale: 0.98 }}
            transition={{ duration: 0.18 }}
            className="pointer-events-auto mb-2"
          >
            <div
              className={`p-3 rounded-2xl border ${
                t.type === "warn"
                  ? "bg-amber-500/10 border-amber-500/20"
                  : t.type === "danger"
                  ? "bg-rose-500/10 border-rose-500/20"
                  : "bg-white/80 dark:bg-white/8 border-black/10 dark:border-white/10"
              } backdrop-blur`}
            >
              <div className="flex items-start justify-between gap-3">
                <div>
                  <div className="text-[12px] font-semibold text-zinc-950/90 dark:text-white/90">
                    {t.title}
                  </div>
                  <div className="text-[12px] text-zinc-950/70 dark:text-white/70 mt-1 leading-snug">
                    {t.body}
                  </div>
                </div>
                <button
                  onClick={() => onClear(t.id)}
                  className="text-zinc-950/50 dark:text-white/50 hover:text-zinc-950/80 dark:hover:text-white/80 text-[12px]"
                >
                  ✕
                </button>
              </div>
            </div>
          </motion.div>
        ))}
      </AnimatePresence>
    </div>
  );
}

function TopBar({ title, left, right }) {
  const { mode, route, hasPremium, openPaywall } = useApp();

  return (
    <div className="px-4 pt-4 pb-3">
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-2">
          {left}
          <div className="flex flex-col">
            <div className="text-[13px] font-semibold text-zinc-950/90 dark:text-white/90">
              {title}
            </div>
            <div className="text-[11px] text-zinc-950/50 dark:text-white/50">
              Mode: {theme.modes[mode].name}
            </div>
          </div>
        </div>

        <div className="flex items-center gap-2">
          {right}
          {!hasPremium && route !== ROUTES.Paywall && route !== ROUTES.Premium ? (
            <button
              onClick={() => openPaywall("Upgrade to Premium")}
              className="inline-flex items-center gap-2 px-3 py-2 rounded-2xl border border-amber-500/25 bg-amber-500/10 hover:bg-amber-500/14 text-[12px] font-semibold text-amber-900/90 dark:text-amber-100 active:scale-[0.99]"
            >
              <Lock size={16} className="opacity-90" />
              Upgrade
            </button>
          ) : null}
        </div>
      </div>
    </div>
  );
}

function ScreenShell({ title, children, left, right, footer }) {
  return (
    <div className="relative h-full w-full">
      <TopBar title={title} left={left} right={right} />
      <div className="px-4 pb-5">{children}</div>
      {footer ? (
        <div className="absolute left-0 right-0 bottom-0 p-4 bg-gradient-to-t from-black/10 dark:from-black/70 to-transparent">
          {footer}
        </div>
      ) : null}
    </div>
  );
}

function MobileFrame({ children }) {
  const { route } = useApp();
  const accent = routeAccents[route] ?? fallbackAccent;
  const accentLine = routeAccentLines[route] ?? "from-white/35 via-white/10 to-transparent";

  return (
    <div
      className={`relative w-[390px] max-w-[92vw] aspect-[9/19] ${theme.radius.lg} ${theme.shadow.card} overflow-hidden border border-black/10 dark:border-white/10`}
      style={{ fontFamily: theme.font.family }}
    >
      <div className="absolute inset-0 bg-zinc-950" />
      <div className="absolute inset-0 bg-gradient-to-b from-black/5 dark:from-white/8 via-transparent to-transparent" />

      <div
        className={`absolute -top-24 left-1/2 -translate-x-1/2 w-[520px] h-[520px] rounded-full bg-gradient-to-b ${accent} blur-3xl`}
      />

      <div className="absolute top-0 left-0 right-0 h-10 flex items-center justify-between px-4 text-[11px] text-zinc-950/60 dark:text-white/60 z-50">
        <div className="flex items-center gap-2">
          <div className="w-2 h-2 rounded-full bg-emerald-400/70" />
          <span>Live</span>
        </div>
        <div className="flex items-center gap-2">
          <span>9:41</span>
          <span className="opacity-60">•</span>
          <span>5G</span>
          <span className="opacity-60">•</span>
          <span>92%</span>
        </div>
      </div>

      <div className="absolute left-0 right-0 top-10 z-40">
        <div
          className={`h-[2px] bg-gradient-to-r ${accentLine}`}
          style={{ filter: "saturate(1.15)" }}
        />
        <div className="h-[10px] bg-gradient-to-b from-black/6 dark:from-white/6 to-transparent" />
      </div>

      <div className="relative h-full pt-8">{children}</div>
    </div>
  );
}

function ScreenTransition({ routeKey, children }) {
  return (
    <AnimatePresence mode="wait" initial={false}>
      <motion.div
        key={routeKey}
        initial={{ opacity: 0, y: 8, scale: 0.995 }}
        animate={{ opacity: 1, y: 0, scale: 1 }}
        exit={{ opacity: 0, y: -8, scale: 0.995 }}
        transition={{ duration: 0.22, ease: [0.2, 0.8, 0.2, 1] }}
        className="h-full"
      >
        {children}
      </motion.div>
    </AnimatePresence>
  );
}

// ───────────────────────────────────────────────────────────────────────────────
// FEATURES: ONBOARDING
// ───────────────────────────────────────────────────────────────────────────────
function WelcomeScreen() {
  const { navTo, setMode, openPaywall } = useApp();

  return (
    <ScreenShell
      title="The Briefing Master"
      left={
        <div className="w-9 h-9 rounded-2xl bg-black/5 dark:bg-white/10 border border-black/10 dark:border-white/10 flex items-center justify-center">
          <Sparkles size={18} className="text-cyan-700 dark:text-cyan-200" />
        </div>
      }
      right={<Pill icon={ShieldCheck} label="Private • RLS" variant="muted" />}
      footer={
        <div className="space-y-2">
          <PrimaryButton
            icon={ArrowRight}
            onClick={() => {
              setMode("deepWork");
              navTo(ROUTES.Onboarding);
            }}
          >
            Start your Executive Upgrade
          </PrimaryButton>

          <SecondaryButton
            icon={Lock}
            onClick={() => {
              setMode("deepWork");
              openPaywall("Competency Map + Pricing");
            }}
          >
            View Paywall (Pricing)
          </SecondaryButton>

          <div className="text-[11px] text-zinc-950/50 dark:text-white/50 text-center">
            Frictionless onboarding • Immediate “Aha” moment • Built for retention
          </div>
        </div>
      }
    >
      <div className="mt-3 space-y-4">
        <div className="p-4 rounded-3xl border border-black/10 dark:border-white/10 bg-white/70 dark:bg-white/5">
          <div className="flex items-center justify-between">
            <div>
              <div className="text-[14px] font-semibold text-zinc-950/90 dark:text-white/90">
                From Meeting Anxiety → Performance Flow
              </div>
              <div className="text-[12px] text-zinc-950/60 dark:text-white/60 mt-1">
                Prime. Speak. Drill. Anchor. Repeat.
              </div>
            </div>
            <div className="w-10 h-10 rounded-2xl bg-cyan-500/12 border border-cyan-500/20 flex items-center justify-center">
              <Zap size={18} className="text-cyan-700 dark:text-cyan-200" />
            </div>
          </div>
          <div className="mt-4 grid grid-cols-3 gap-2">
            <MiniStat title="Sophistication" value="+38" hint="Tier upgrades" />
            <MiniStat title="Filler control" value="-62%" hint="Hesitations" />
            <MiniStat title="LTV driver" value="Streak" hint="Dopamine loop" />
          </div>
        </div>

        <div className="p-4 rounded-3xl border border-black/10 dark:border-white/10 bg-gradient-to-b from-black/5 dark:from-white/6 to-transparent">
          <div className="text-[12px] text-zinc-950/60 dark:text-white/60">Your unfair advantage</div>
          <div className="text-[14px] font-semibold text-zinc-950/90 dark:text-white/90 mt-1">
            Personalized training using your CV + real dashboards.
          </div>
          <div className="text-[12px] text-zinc-950/60 dark:text-white/60 mt-2 leading-snug">
            We don’t teach “random English.” We teach{" "}
            <span className="text-zinc-950/85 dark:text-white/85">your English</span> — for your meetings,
            your metrics, your pressure.
          </div>
        </div>

        <div className="flex gap-2">
          <button
            onClick={() => setMode("deepWork")}
            className="flex-1 px-3 py-2 rounded-2xl bg-black/5 dark:bg-white/6 border border-black/10 dark:border-white/10 text-[12px] text-zinc-950/75 dark:text-white/75 hover:bg-black/10 dark:hover:bg-white/8"
          >
            Deep Work
          </button>
          <button
            onClick={() => setMode("adrenaline")}
            className="flex-1 px-3 py-2 rounded-2xl bg-black/5 dark:bg-white/6 border border-black/10 dark:border-white/10 text-[12px] text-zinc-950/75 dark:text-white/75 hover:bg-black/10 dark:hover:bg-white/8"
          >
            Adrenaline
          </button>
          <button
            onClick={() => setMode("focus")}
            className="flex-1 px-3 py-2 rounded-2xl bg-black/5 dark:bg-white/6 border border-black/10 dark:border-white/10 text-[12px] text-zinc-950/75 dark:text-white/75 hover:bg-black/10 dark:hover:bg-white/8"
          >
            Focus
          </button>
        </div>
      </div>
    </ScreenShell>
  );
}

function MiniStat({ title, value, hint }) {
  return (
    <div className="p-2 rounded-2xl bg-white/70 dark:bg-white/5 border border-black/10 dark:border-white/10">
      <div className="text-[10px] text-zinc-950/50 dark:text-white/50">{title}</div>
      <div className="text-[14px] font-semibold text-zinc-950/90 dark:text-white/90 mt-0.5">{value}</div>
      <div className="text-[10px] text-zinc-950/45 dark:text-white/45 mt-0.5">{hint}</div>
    </div>
  );
}

function OnboardingScreen() {
  const { navTo, profile, setProfile } = useApp();

  return (
    <ScreenShell
      title="Onboarding"
      left={<BackButton />}
      right={<Pill icon={Layers} label="FTUE" />}
      footer={
        <div className="space-y-2">
          <PrimaryButton icon={ArrowRight} onClick={() => navTo(ROUTES.Upload)}>
            Personalize (CV / Dashboard)
          </PrimaryButton>
          <SecondaryButton
            onClick={() => {
              setProfile({ ...profile, hydrated: false });
              navTo(ROUTES.Priming);
            }}
          >
            Skip personalization (demo)
          </SecondaryButton>
        </div>
      }
    >
      <div className="space-y-3">
        <div className="p-4 rounded-3xl border border-black/10 dark:border-white/10 bg-white/70 dark:bg-white/5">
          <div className="text-[12px] text-zinc-950/55 dark:text-white/55">Your mission</div>
          <div className="mt-1 text-[15px] font-semibold text-zinc-950/90 dark:text-white/90">
            Sound credible under pressure — without overthinking.
          </div>
          <div className="mt-2 text-[12px] text-zinc-950/60 dark:text-white/60 leading-snug">
            We build a neural shortcut: your brain learns executive phrasing as a reflex.
          </div>
        </div>

        <div className="grid grid-cols-2 gap-2">
          <OnboardCard
            icon={MessageSquareText}
            title="Real-time coach"
            body="Streaming feedback while you speak — tone, structure, fillers."
          />
          <OnboardCard
            icon={BarChart3}
            title="Sophistication Score"
            body="No binary grading. We measure executive polish + clarity."
          />
          <OnboardCard
            icon={Zap}
            title="Hook Model"
            body="Triggers → action → reward → investment → retention loop."
          />
          <OnboardCard
            icon={ShieldCheck}
            title="Private by design"
            body="Your documents are isolated via RLS (multi-tenant security)."
          />
        </div>

        <div className="p-4 rounded-3xl border border-black/10 dark:border-white/10 bg-gradient-to-b from-cyan-500/10 to-transparent">
          <div className="text-[12px] font-semibold text-zinc-950/85 dark:text-white/85">
            Endowment Effect
          </div>
          <div className="text-[12px] text-zinc-950/60 dark:text-white/60 mt-1 leading-snug">
            Uploading your CV/dashboard makes the product feel already “yours.” Your brain values what it invests in —
            leading to higher activation and LTV.
          </div>
        </div>
      </div>
    </ScreenShell>
  );
}

function OnboardCard({ icon: Icon, title, body }) {
  return (
    <div className="p-3 rounded-3xl bg-white/70 dark:bg-white/5 border border-black/10 dark:border-white/10">
      <div className="w-9 h-9 rounded-2xl bg-black/5 dark:bg-white/6 border border-black/10 dark:border-white/10 flex items-center justify-center">
        <Icon size={16} className="text-zinc-950/80 dark:text-white/80" />
      </div>
      <div className="mt-2 text-[13px] font-semibold text-zinc-950/90 dark:text-white/90">{title}</div>
      <div className="mt-1 text-[11px] text-zinc-950/55 dark:text-white/55 leading-snug">{body}</div>
    </div>
  );
}

function UploadScreen() {
  const { navTo, profile, setProfile, hasPremium, openPaywall } = useApp();
  const [role, setRole] = useState(profile.role);
  const [company, setCompany] = useState(profile.company);
  const [metric, setMetric] = useState(profile.dashboardMetric);
  const [target, setTarget] = useState(profile.target);
  const [uploading, setUploading] = useState(false);

  return (
    <ScreenShell
      title="Personalization"
      left={<BackButton />}
      right={<Pill icon={Upload} label="RAG Upload" />}
      footer={
        <div className="space-y-2">
          <PrimaryButton
            icon={Upload}
            disabled={uploading}
            onClick={() => {
              if (!hasPremium) {
                openPaywall("Personalization (CV/Dashboard RAG)");
                return;
              }

              setUploading(true);
              setTimeout(() => {
                setProfile({
                  hydrated: true,
                  role,
                  company,
                  dashboardMetric: metric,
                  target,
                  language: "English",
                });
                setUploading(false);
                navTo(ROUTES.Priming);
              }, 900);
            }}
          >
            {uploading ? "Analyzing… Hydrating context" : "Upload & Hydrate My Context"}
          </PrimaryButton>
          <div className="text-[11px] text-zinc-950/50 dark:text-white/50 text-center">
            Simulated pipeline: Supabase Storage → NestJS gateway → Python RAG → pgvector
            {!hasPremium ? (
              <span className="block mt-1 text-amber-700/90 dark:text-amber-200">
                Locked in Free. Upgrade to unlock personalization.
              </span>
            ) : null}
          </div>
        </div>
      }
    >
      <div className="space-y-3">
        <div className="p-4 rounded-3xl border border-black/10 dark:border-white/10 bg-white/70 dark:bg-white/5">
          <div className="text-[12px] text-zinc-950/60 dark:text-white/60">Upload simulation</div>
          <div className="text-[14px] font-semibold text-zinc-950/90 dark:text-white/90 mt-1">
            Make the app feel like it already “knows your career.”
          </div>
          <div className="text-[12px] text-zinc-950/60 dark:text-white/60 mt-2 leading-snug">
            This is not a form — it’s an investment trigger. The moment you input your reality, your brain commits.
          </div>
        </div>

        <Field label="Your role">
          <select
            value={role}
            onChange={(e) => setRole(e.target.value)}
            className="w-full px-3 py-3 rounded-2xl bg-black/5 dark:bg-black/30 border border-black/10 dark:border-white/10 text-zinc-950/90 dark:text-white/90 text-[13px]"
          >
            <option>Support N2</option>
            <option>Project Manager</option>
            <option>Sales Executive</option>
            <option>Engineering Manager</option>
          </select>
        </Field>

        <Field label="Company context">
          <input
            value={company}
            onChange={(e) => setCompany(e.target.value)}
            className="w-full px-3 py-3 rounded-2xl bg-black/5 dark:bg-black/30 border border-black/10 dark:border-white/10 text-zinc-950/90 dark:text-white/90 text-[13px]"
            placeholder="e.g., Northstar Systems"
          />
        </Field>

        <Field label="Dashboard metric (high-stakes reality)">
          <input
            value={metric}
            onChange={(e) => setMetric(e.target.value)}
            className="w-full px-3 py-3 rounded-2xl bg-black/5 dark:bg-black/30 border border-black/10 dark:border-white/10 text-zinc-950/90 dark:text-white/90 text-[13px]"
            placeholder="e.g., Q3 revenue down 20%"
          />
        </Field>

        <Field label="Your target identity">
          <input
            value={target}
            onChange={(e) => setTarget(e.target.value)}
            className="w-full px-3 py-3 rounded-2xl bg-black/5 dark:bg-black/30 border border-black/10 dark:border-white/10 text-zinc-950/90 dark:text-white/90 text-[13px]"
            placeholder="e.g., Sound like an Executive in crisis calls"
          />
        </Field>

        <div className="p-4 rounded-3xl border border-black/10 dark:border-white/10 bg-gradient-to-b from-black/5 dark:from-white/6 to-transparent">
          <div className="text-[12px] font-semibold text-zinc-950/85 dark:text-white/85">
            What changes after hydration?
          </div>
          <div className="mt-2 space-y-2 text-[12px] text-zinc-950/60 dark:text-white/60 leading-snug">
            <div className="flex items-start gap-2">
              <CheckCircle2 size={16} className="text-emerald-600 dark:text-emerald-200 mt-0.5" />
              <span>Scenarios reference your role, your metrics, your pressure.</span>
            </div>
            <div className="flex items-start gap-2">
              <CheckCircle2 size={16} className="text-emerald-600 dark:text-emerald-200 mt-0.5" />
              <span>Tier 3 rewrites adopt executive tone aligned to your domain.</span>
            </div>
            <div className="flex items-start gap-2">
              <CheckCircle2 size={16} className="text-emerald-600 dark:text-emerald-200 mt-0.5" />
              <span>Feedback becomes contextual, not generic. Higher perceived value → higher conversion.</span>
            </div>
          </div>
        </div>
      </div>
    </ScreenShell>
  );
}

function Field({ label, children }) {
  return (
    <div className="space-y-1">
      <div className="text-[11px] text-zinc-950/55 dark:text-white/55">{label}</div>
      {children}
    </div>
  );
}

// ───────────────────────────────────────────────────────────────────────────────
// FEATURES: PRIMING (Stage 1)
// ───────────────────────────────────────────────────────────────────────────────
function PrimingScreen() {
  const { navTo, profile, setMode } = useApp();
  const [cluster, setCluster] = useState("Sharing bad news");
  const pool = semanticPools[cluster];

  return (
    <ScreenShell
      title="Cognitive Priming"
      left={<BackButton />}
      right={<Pill icon={Sparkles} label="Stage 1/4" variant="muted" />}
      footer={
        <div className="space-y-2">
          <PrimaryButton
            icon={Mic}
            onClick={() => {
              setMode("adrenaline");
              navTo(ROUTES.Speaking);
            }}
          >
            Enter Focus Mode (Speaking)
          </PrimaryButton>
          <SecondaryButton
            icon={ArrowRight}
            onClick={() => {
              setMode("focus");
              navTo(ROUTES.Quiz);
            }}
          >
            Skip to Quiz (demo)
          </SecondaryButton>
        </div>
      }
    >
      <div className="space-y-3">
        <div className="p-4 rounded-3xl border border-black/10 dark:border-white/10 bg-white/70 dark:bg-white/5">
          <div className="flex items-center justify-between gap-2">
            <div>
              <div className="text-[12px] text-zinc-950/55 dark:text-white/55">Scenario</div>
              <div className="text-[15px] font-semibold text-zinc-950/90 dark:text-white/90 mt-1">
                {baseScenario.title}
              </div>
              <div className="text-[12px] text-zinc-950/60 dark:text-white/60 mt-1 leading-snug">
                {baseScenario.description}
              </div>
            </div>
            <div className="w-11 h-11 rounded-2xl bg-black/5 dark:bg-white/6 border border-black/10 dark:border-white/10 flex items-center justify-center">
              <AlertTriangle size={18} className="text-amber-600 dark:text-amber-200" />
            </div>
          </div>

          <div className="mt-3 flex flex-wrap gap-2">
            <Pill
              icon={ShieldCheck}
              label={profile.hydrated ? `Hydrated: ${profile.role}` : "Not hydrated"}
              variant={profile.hydrated ? "success" : "warn"}
            />
            <Pill icon={BarChart3} label={profile.dashboardMetric} variant="muted" />
          </div>
        </div>

        <div className="p-4 rounded-3xl border border-black/10 dark:border-white/10 bg-gradient-to-b from-black/5 dark:from-white/6 to-transparent">
          <div className="flex items-center justify-between">
            <div>
              <div className="text-[12px] text-zinc-950/55 dark:text-white/55">Intent cluster</div>
              <div className="text-[14px] font-semibold text-zinc-950/90 dark:text-white/90 mt-1">
                {cluster}
              </div>
            </div>
            <select
              value={cluster}
              onChange={(e) => setCluster(e.target.value)}
              className="px-3 py-2 rounded-2xl bg-black/5 dark:bg-black/30 border border-black/10 dark:border-white/10 text-zinc-950/85 dark:text-white/85 text-[12px]"
            >
              {Object.keys(semanticPools).map((k) => (
                <option key={k}>{k}</option>
              ))}
            </select>
          </div>

          <div className="mt-3 grid grid-cols-2 gap-2">
            <PrimeCard title="Power Verbs" items={pool.powerVerbs} />
            <PrimeCard title="Connectors" items={pool.connectors} />
          </div>
        </div>

        <div className="p-4 rounded-3xl border border-black/10 dark:border-white/10 bg-white/70 dark:bg-white/5">
          <div className="flex items-center justify-between">
            <div>
              <div className="text-[12px] text-zinc-950/55 dark:text-white/55">Tri-tier vocabulary</div>
              <div className="text-[12px] text-zinc-950/60 dark:text-white/60 mt-1">
                Flip cards to prime executive phrasing.
              </div>
            </div>
            <Pill icon={Layers} label="Tiers" />
          </div>

          <div className="mt-3 space-y-2">
            <FlipCard tier="Tier 1" subtitle="Safe / Functional" front={pool.tier1[0]} back={pool.tier2[0]} />
            <FlipCard tier="Tier 2" subtitle="Professional / Fluent" front={pool.tier2[1]} back={pool.tier3[1]} />
            <FlipCard
              tier="Tier 3"
              subtitle="Executive / Persuasive"
              front={pool.tier3[0]}
              back="Now commit: timeline + impact + mitigation."
            />
          </div>
        </div>

        <div className="p-4 rounded-3xl border border-black/10 dark:border-white/10 bg-gradient-to-b from-cyan-500/10 to-transparent">
          <div className="text-[12px] font-semibold text-zinc-950/90 dark:text-white/90">Priming psychology</div>
          <div className="text-[12px] text-zinc-950/60 dark:text-white/60 mt-2 leading-snug">
            We reduce cognitive load by preloading patterns (verbs + connectors). This turns “thinking” into “reflex.”
            Better reflex → less anxiety → higher performance flow.
          </div>
        </div>
      </div>
    </ScreenShell>
  );
}

function PrimeCard({ title, items }) {
  return (
    <div className="p-3 rounded-3xl bg-white/70 dark:bg-black/20 border border-black/10 dark:border-white/10">
      <div className="text-[11px] text-zinc-950/55 dark:text-white/55">{title}</div>
      <div className="mt-2 flex flex-wrap gap-2">
        {items.map((x) => (
          <span
            key={x}
            className="px-2.5 py-1 rounded-full bg-black/5 dark:bg-white/6 border border-black/10 dark:border-white/10 text-[11px] text-zinc-950/75 dark:text-white/75"
          >
            {x}
          </span>
        ))}
      </div>
    </div>
  );
}

function FlipCard({ tier, subtitle, front, back }) {
  const [flipped, setFlipped] = useState(false);

  return (
    <button onClick={() => setFlipped((v) => !v)} className="w-full text-left">
      <motion.div
        initial={false}
        animate={{ rotateX: flipped ? 180 : 0 }}
        transition={{ duration: 0.42, ease: [0.2, 0.8, 0.2, 1] }}
        className="relative [transform-style:preserve-3d]"
      >
        <div className="absolute inset-0 [backface-visibility:hidden]">
          <div className="p-3 rounded-3xl bg-white/70 dark:bg-white/5 border border-black/10 dark:border-white/10">
            <div className="flex items-center justify-between">
              <div>
                <div className="text-[11px] text-zinc-950/55 dark:text-white/55">{tier}</div>
                <div className="text-[12px] font-semibold text-zinc-950/85 dark:text-white/85">{subtitle}</div>
              </div>
              <div className="text-[11px] text-zinc-950/50 dark:text-white/50">tap to flip</div>
            </div>
            <div className="mt-2 text-[12px] text-zinc-950/80 dark:text-white/80 leading-snug">“{front}”</div>
          </div>
        </div>

        <div className="[transform:rotateX(180deg)] [backface-visibility:hidden]">
          <div className="p-3 rounded-3xl bg-gradient-to-b from-black/5 dark:from-white/8 to-transparent border border-black/10 dark:border-white/10">
            <div className="flex items-center justify-between">
              <div>
                <div className="text-[11px] text-zinc-950/55 dark:text-white/55">Upgrade suggestion</div>
                <div className="text-[12px] font-semibold text-zinc-950/85 dark:text-white/85">Executive polish</div>
              </div>
              <div className="text-[11px] text-zinc-950/50 dark:text-white/50">tap to flip</div>
            </div>
            <div className="mt-2 text-[12px] text-zinc-950/80 dark:text-white/80 leading-snug">“{back}”</div>
          </div>
        </div>
      </motion.div>
      <div className="h-[86px]" />
    </button>
  );
}

// ───────────────────────────────────────────────────────────────────────────────
// FEATURES: SPEAKING (Stage 2)
// ───────────────────────────────────────────────────────────────────────────────
function SpeakingScreen() {
  const { navTo, profile, setMode, hasPremium, openPaywall } = useApp();
  const [isSpeaking, setIsSpeaking] = useState(false);
  const [transcript, setTranscript] = useState("");
  const [toasts, setToasts] = useState([]);
  const [score, setScore] = useState(50);
  const [cluster, setCluster] = useState("Sharing bad news");
  const [upgrade, setUpgrade] = useState(null);

  const derived = useMemo(() => {
    const intent = detectIntentCluster(transcript);
    const s = computeSophisticationScore(transcript);
    return { intent, score: s };
  }, [transcript]);

  useEffect(() => {
    setCluster(derived.intent);
    setScore(derived.score);
  }, [derived.intent, derived.score]);

  useMockCoachStream(hasPremium && isSpeaking, (msg) => setToasts((t) => [msg, ...t].slice(0, 8)), profile);

  useEffect(() => {
    if (!isSpeaking) return;
    const pool = semanticPools[cluster] ?? semanticPools["Sharing bad news"];

    const candidates = [
      `So, uh, we have a problem. ${profile.dashboardMetric}. I'm looking into it and we will fix it soon.`,
      `First, ${profile.dashboardMetric}. Second, we identified two drivers. Therefore, we are executing a mitigation plan and will provide a revised timeline within the hour.`,
      `Net-net: ${profile.dashboardMetric}. My recommendation is to stabilize churn risk, quantify impact, and align on corrective actions today.`,
      `${pick(pool.connectors)}: the variance is material. We’re investigating root cause and confirming corrective actions with a measurable ETA.`,
    ];

    let idx = 0;
    const seed = pick(candidates);

    const id = setInterval(() => {
      setTranscript((prev) => seed.slice(0, Math.min(seed.length, prev.length + 6)));
      idx += 1;
      if (idx > 70) clearInterval(id);
    }, 120);

    return () => clearInterval(id);
  }, [isSpeaking, cluster, profile.dashboardMetric]);

  useEffect(() => {
    if (!isSpeaking) return;
    const id = setTimeout(() => setIsSpeaking(false), 7200);
    return () => clearTimeout(id);
  }, [isSpeaking]);

  const pool = semanticPools[cluster] ?? semanticPools["Sharing bad news"];

  const professionalism = useMemo(() => {
    if (score >= 78) return { label: "Executive", icon: Crown, variant: "success" };
    if (score >= 56) return { label: "Professional", icon: ShieldCheck, variant: "muted" };
    return { label: "Safe", icon: AlertTriangle, variant: "warn" };
  }, [score]);

  return (
    <div className="relative h-full">
      <ToastStack items={toasts} onClear={(id) => setToasts((t) => t.filter((x) => x.id !== id))} />

      <ScreenShell
        title="Focus Mode"
        left={<BackButton />}
        right={
          hasPremium ? (
            <Pill icon={Mic} label="Premium coach" variant="success" />
          ) : (
            <Pill icon={Lock} label="Coach locked" variant="warn" />
          )
        }
        footer={
          <div className="space-y-2">
            <PrimaryButton
              icon={ArrowRight}
              onClick={() => {
                setMode("focus");
                navTo(ROUTES.Quiz);
              }}
            >
              Continue → Speed Synonyms (Quiz)
            </PrimaryButton>
            <SecondaryButton icon={ArrowRight} onClick={() => navTo(ROUTES.Revision)}>
              Jump to Battle-Card Summary
            </SecondaryButton>
          </div>
        }
      >
        <div className="space-y-3">
          <div className="p-4 rounded-3xl border border-black/10 dark:border-white/10 bg-gradient-to-b from-rose-500/12 to-transparent">
            <div className="flex items-start justify-between gap-3">
              <div>
                <div className="text-[12px] text-zinc-950/55 dark:text-white/55">Live briefing prompt</div>
                <div className="mt-1 text-[14px] font-semibold text-zinc-950/90 dark:text-white/90">
                  Explain why <span className="text-zinc-950 dark:text-white">{profile.dashboardMetric}</span> happened,
                  and propose a recovery plan.
                </div>
                <div className="mt-2 text-[12px] text-zinc-950/60 dark:text-white/60 leading-snug">
                  Speak like leadership is listening. No apologies. Commit to action.
                </div>
              </div>
              <div className="w-11 h-11 rounded-2xl bg-rose-500/12 border border-rose-500/20 flex items-center justify-center">
                <Zap size={18} className="text-rose-700 dark:text-rose-200" />
              </div>
            </div>
          </div>

          <div className="p-4 rounded-3xl border border-black/10 dark:border-white/10 bg-white/70 dark:bg-white/5">
            <div className="flex items-center justify-between">
              <div>
                <div className="text-[11px] text-zinc-950/55 dark:text-white/55">Voice waveform</div>
                <div className="text-[12px] font-semibold text-zinc-950/85 dark:text-white/85">Audio Visualizer</div>
              </div>
              <Pill
                icon={professionalism.icon}
                label={`${professionalism.label} • ${score}/100`}
                variant={professionalism.variant}
              />
            </div>

            <div className="mt-3">
              <AudioVisualizer active={isSpeaking} />
            </div>

            <div className="mt-3 flex gap-2">
              <button
                onClick={() => {
                  setTranscript("");
                  setUpgrade(null);
                  setIsSpeaking(true);
                }}
                className={`flex-1 px-3 py-3 rounded-2xl font-semibold border ${
                  isSpeaking
                    ? "bg-black/5 dark:bg-white/10 border-black/10 dark:border-white/10 text-zinc-950/60 dark:text-white/60"
                    : "bg-zinc-950 text-white dark:bg-white dark:text-zinc-950 border-black/10 dark:border-white/10"
                }`}
                disabled={isSpeaking}
              >
                {isSpeaking ? "Listening…" : "Start speaking"}
              </button>

              <button
                onClick={() => {
                  if (!hasPremium) {
                    openPaywall("Tier 3 Executive Rewrite + Live Coach");
                    return;
                  }

                  setIsSpeaking(false);
                  const intent = detectIntentCluster(transcript);
                  const up = generateTierUpgrade(transcript, intent);
                  setUpgrade(up);
                  setToasts((t) => [
                    {
                      id: `${Date.now()}-upgrade`,
                      type: "tip",
                      title: "Upgrade Ready",
                      body: "Your Tier 3 rewrite is prepared. Apply it for the Aha moment.",
                      ts: Date.now(),
                    },
                    ...t,
                  ]);
                }}
                className="flex-1 px-3 py-3 rounded-2xl font-semibold bg-black/5 dark:bg-white/10 border border-black/10 dark:border-white/10 text-zinc-950 dark:text-white hover:bg-black/10 dark:hover:bg-white/12"
              >
                {hasPremium ? "Generate Upgrade" : "Unlock Tier 3 (Premium)"}
              </button>
            </div>
          </div>

          <div className="p-4 rounded-3xl border border-black/10 dark:border-white/10 bg-white/70 dark:bg-black/25">
            <div className="flex items-center justify-between">
              <div>
                <div className="text-[11px] text-zinc-950/55 dark:text-white/55">Streaming transcript</div>
                <div className="text-[12px] font-semibold text-zinc-950/85 dark:text-white/85">What you’re saying</div>
              </div>
              <Pill icon={Layers} label={`Intent: ${cluster}`} />
            </div>

            <div className="mt-2 text-[12px] text-zinc-950/70 dark:text-white/70 leading-snug min-h-[64px]">
              {transcript ? (
                <span>
                  {transcript}
                  {isSpeaking ? (
                    <span className="inline-block w-2 h-4 ml-1 bg-zinc-950/60 dark:bg-white/60 align-middle animate-pulse" />
                  ) : null}
                </span>
              ) : (
                <span className="text-zinc-950/40 dark:text-white/40">
                  Tap “Start speaking” to simulate live meeting talk.
                </span>
              )}
            </div>

            <div className="mt-3">
              <div className="flex items-center justify-between text-[11px] text-zinc-950/50 dark:text-white/50">
                <span>Sophistication Score</span>
                <span className="text-zinc-950/75 dark:text-white/75 font-semibold">{score}/100</span>
              </div>
              <div className="mt-2">
                <ProgressBar value={score} />
              </div>
              <div className="mt-2 text-[11px] text-zinc-950/50 dark:text-white/50">
                Not a pass/fail. We measure executive clarity, structure, and commitment.
              </div>
            </div>
          </div>

          <div className="p-4 rounded-3xl border border-black/10 dark:border-white/10 bg-white/70 dark:bg-white/5">
            <div className="flex items-center justify-between">
              <div>
                <div className="text-[11px] text-zinc-950/55 dark:text-white/55">Tier upgrades</div>
                <div className="text-[12px] font-semibold text-zinc-950/85 dark:text-white/85">Executive rewrite path</div>
              </div>
              <Pill icon={Crown} label="Aha Moment" variant="success" />
            </div>

            {!upgrade ? (
              <div className="mt-2 text-[12px] text-zinc-950/55 dark:text-white/55 leading-snug">
                {hasPremium
                  ? "Generate the Tier 3 rewrite. This is the first time the user hears themselves as an Executive."
                  : "Tier 3 rewrites are Premium. In Free, you can practice speaking + quiz, but executive rewrite is locked."}
              </div>
            ) : (
              <div className="mt-3 space-y-2">
                <UpgradeBlock label="Tier 2 (Professional)" text={upgrade.tier2} />

                {hasPremium ? (
                  <UpgradeBlock label="Tier 3 (Executive)" text={upgrade.tier3} strong />
                ) : (
                  <div className="p-3 rounded-2xl border bg-amber-500/10 border-amber-500/20">
                    <div className="flex items-center justify-between gap-3">
                      <div className="min-w-0">
                        <div className="text-[11px] text-amber-900/90 dark:text-amber-100">
                          Tier 3 (Executive) — Locked
                        </div>
                        <div className="mt-1 text-[12px] text-amber-900/80 dark:text-amber-100/80 leading-snug blur-[1.6px] select-none">
                          “{upgrade.tier3}”
                        </div>
                      </div>
                      <button
                        onClick={() => openPaywall("Tier 3 Executive Rewrite")}
                        className="shrink-0 px-3 py-2 rounded-2xl bg-zinc-950 text-white dark:bg-white dark:text-zinc-950 text-[12px] font-semibold"
                      >
                        Unlock
                      </button>
                    </div>
                  </div>
                )}

                <div className="text-[11px] text-zinc-950/50 dark:text-white/50">{upgrade.rationale}</div>
              </div>
            )}

            <div className="mt-3 p-3 rounded-2xl bg-black/5 dark:bg-black/30 border border-black/10 dark:border-white/10">
              <div className="text-[11px] text-zinc-950/55 dark:text-white/55">Suggested connectors</div>
              <div className="mt-2 flex flex-wrap gap-2">
                {pool.connectors.map((c) => (
                  <span
                    key={c}
                    className="px-2.5 py-1 rounded-full bg-black/5 dark:bg-white/6 border border-black/10 dark:border-white/10 text-[11px] text-zinc-950/75 dark:text-white/75"
                  >
                    {c}
                  </span>
                ))}
              </div>
            </div>
          </div>
        </div>
      </ScreenShell>
    </div>
  );
}

function UpgradeBlock({ label, text, strong }) {
  return (
    <div
      className={`p-3 rounded-2xl border ${
        strong
          ? "bg-emerald-500/10 border-emerald-500/20"
          : "bg-white/70 dark:bg-white/5 border-black/10 dark:border-white/10"
      }`}
    >
      <div className="text-[11px] text-zinc-950/55 dark:text-white/55">{label}</div>
      <div
        className={`mt-1 text-[12px] leading-snug ${
          strong ? "text-emerald-900/90 dark:text-emerald-100" : "text-zinc-950/80 dark:text-white/80"
        }`}
      >
        “{text}”
      </div>
    </div>
  );
}

function AudioVisualizer({ active }) {
  const [seed, setSeed] = useState(0.4);

  useEffect(() => {
    if (!active) return;
    const id = setInterval(() => setSeed(0.25 + Math.random() * 0.75), 140);
    return () => clearInterval(id);
  }, [active]);

  const bars = new Array(18).fill(0).map((_, i) => {
    const base = 0.25 + Math.abs(Math.sin((i + 1) * 0.9)) * 0.45;
    const amp = active ? seed : 0.18;
    return clamp(base * amp * 100, 8, 100);
  });

  return (
    <div className="w-full h-14 rounded-2xl bg-black/5 dark:bg-black/35 border border-black/10 dark:border-white/10 flex items-center justify-center px-3">
      <div className="flex items-end gap-1 w-full">
        {bars.map((h, idx) => (
          <motion.div
            key={idx}
            className="flex-1 rounded-full bg-zinc-950/80 dark:bg-white/70"
            animate={{ height: `${h}%`, opacity: active ? 0.95 : 0.45 }}
            transition={{ duration: 0.16, ease: [0.2, 0.8, 0.2, 1] }}
            style={{ height: `${h}%` }}
          />
        ))}
      </div>
    </div>
  );
}

// ───────────────────────────────────────────────────────────────────────────────
// FEATURES: QUIZ (Stage 3)
// ───────────────────────────────────────────────────────────────────────────────
function QuizScreen() {
  const { navTo, profile, setMode, openPaywall } = useApp();
  const [timeLeft, setTimeLeft] = useState(20);
  const [streak, setStreak] = useState(0);
  const [points, setPoints] = useState(120);
  const [promptIdx, setPromptIdx] = useState(0);
  const [answer, setAnswer] = useState("");
  const [result, setResult] = useState(null);

  const challenges = useMemo(
    () => [
      {
        cue: "Upgrade: ‘I’m looking into it.’",
        good: "I’m investigating the root cause and will confirm corrective actions with a measurable ETA.",
        synonyms: ["investigating", "root cause", "corrective actions", "measurable ETA"],
      },
      {
        cue: `Use the metric: “${profile.dashboardMetric}” with leadership tone.`,
        good: `Net-net: ${profile.dashboardMetric}. We’re executing a mitigation plan and will provide a revised timeline within the hour.`,
        synonyms: ["net-net", "mitigation plan", "revised timeline"],
      },
      {
        cue: "Replace apology with ownership.",
        good: "We own the outcome. We identified the driver and we’re stabilizing performance now.",
        synonyms: ["own the outcome", "identified the driver", "stabilizing"],
      },
    ],
    [profile.dashboardMetric]
  );

  useEffect(() => setMode("focus"), [setMode]);

  useEffect(() => {
    const id = setInterval(() => {
      setTimeLeft((t) => (t <= 1 ? 0 : t - 1));
    }, 1000);
    return () => clearInterval(id);
  }, []);

  useEffect(() => {
    if (timeLeft === 0 && !result) {
      setResult({
        ok: false,
        msg: "Time’s up. Executive clarity requires speed under pressure.",
        haptic: "hesitation",
      });
      setStreak(0);
      setPoints((p) => Math.max(0, p - 12));
    }
  }, [timeLeft, result]);

  const current = challenges[promptIdx];

  const submit = () => {
    if (!answer.trim()) return;

    const lower = answer.toLowerCase();
    const hits = current.synonyms.reduce(
      (acc, w) => acc + (lower.includes(w.toLowerCase()) ? 1 : 0),
      0
    );

    const ok = hits >= Math.max(2, Math.floor(current.synonyms.length * 0.6));

    if (ok) {
      setResult({ ok: true, msg: "Correct. Executive-grade synonym mapping detected.", haptic: "correct" });
      setStreak((s) => s + 1);
      setPoints((p) => p + 16);
    } else {
      setResult({ ok: false, msg: "Not quite. Aim for connectors + measurable commitments.", haptic: "hesitation" });
      setStreak(0);
      setPoints((p) => Math.max(0, p - 8));
    }
  };

  const next = () => {
    setResult(null);
    setAnswer("");
    setTimeLeft(20);
    setPromptIdx((i) => (i + 1) % challenges.length);
  };

  const nextReview = useMemo(() => {
    if (streak >= 3) return "in 3 days";
    if (streak === 2) return "in 24 hours";
    if (streak === 1) return "in 6 hours";
    return "in 30 minutes";
  }, [streak]);

  return (
    <ScreenShell
      title="Speed Synonyms"
      left={<BackButton />}
      right={<Pill icon={Timer} label="Stage 3/4" variant="muted" />}
      footer={
        <div className="space-y-2">
          <PrimaryButton icon={ArrowRight} onClick={() => navTo(ROUTES.Revision)}>
            Continue → Battle Card (Revision)
          </PrimaryButton>
          <SecondaryButton
            icon={Lock}
            onClick={() => openPaywall("Competency Map + Pricing")}
          >
            See Paywall
          </SecondaryButton>
        </div>
      }
    >
      <div className="space-y-3">
        <div className="p-4 rounded-3xl border border-black/10 dark:border-white/10 bg-gradient-to-b from-indigo-500/14 to-transparent">
          <div className="flex items-start justify-between gap-3">
            <div>
              <div className="text-[12px] text-zinc-950/55 dark:text-white/55">High-pressure retrieval</div>
              <div className="mt-1 text-[14px] font-semibold text-zinc-950/90 dark:text-white/90">
                Find executive synonyms fast.
              </div>
              <div className="mt-2 text-[12px] text-zinc-950/60 dark:text-white/60 leading-snug">
                This builds a neural shortcut: the right phrase appears automatically under stress.
              </div>
            </div>
            <div className="w-11 h-11 rounded-2xl bg-indigo-500/14 border border-indigo-500/20 flex items-center justify-center">
              <Timer size={18} className="text-indigo-700 dark:text-indigo-200" />
            </div>
          </div>
        </div>

        <div className="p-4 rounded-3xl border border-black/10 dark:border-white/10 bg-white/70 dark:bg-white/5">
          <div className="flex items-center justify-between">
            <Pill icon={Zap} label={`Streak: ${streak}`} variant={streak > 0 ? "success" : "muted"} />
            <Pill icon={Crown} label={`Professionalism Points: ${points}`} variant="muted" />
          </div>

          <div className="mt-3 flex items-center justify-between text-[11px] text-zinc-950/50 dark:text-white/50">
            <span>Time left</span>
            <span
              className={`font-semibold ${
                timeLeft <= 5 ? "text-amber-600 dark:text-amber-200" : "text-zinc-950/80 dark:text-white/80"
              }`}
            >
              {timeLeft}s
            </span>
          </div>
          <div className="mt-2">
            <ProgressBar value={(timeLeft / 20) * 100} />
          </div>

          <div className="mt-3 p-3 rounded-2xl bg-black/5 dark:bg-black/30 border border-black/10 dark:border-white/10">
            <div className="text-[11px] text-zinc-950/55 dark:text-white/55">Prompt</div>
            <div className="mt-1 text-[13px] font-semibold text-zinc-950/90 dark:text-white/90 leading-snug">
              {current.cue}
            </div>
          </div>

          <div className="mt-3">
            <div className="text-[11px] text-zinc-950/55 dark:text-white/55">Your answer</div>
            <textarea
              value={answer}
              onChange={(e) => setAnswer(e.target.value)}
              rows={3}
              className="mt-1 w-full px-3 py-2 rounded-2xl bg-black/5 dark:bg-black/30 border border-black/10 dark:border-white/10 text-zinc-950/90 dark:text-white/90 text-[13px] leading-snug resize-none"
              placeholder="Type your Tier 3 version…"
            />
          </div>

          <div className="mt-3 flex gap-2">
            <button
              onClick={submit}
              className="flex-1 px-3 py-3 rounded-2xl font-semibold bg-zinc-950 text-white dark:bg-white dark:text-zinc-950"
            >
              Submit
            </button>
            <button
              onClick={() => setAnswer(current.good)}
              className="flex-1 px-3 py-3 rounded-2xl font-semibold bg-black/5 dark:bg-white/10 border border-black/10 dark:border-white/10 text-zinc-950 dark:text-white"
            >
              Show best answer
            </button>
          </div>

          {result ? (
            <motion.div
              initial={{ opacity: 0, y: 6 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.18 }}
              className={`mt-3 p-3 rounded-2xl border ${
                result.ok ? "bg-emerald-500/10 border-emerald-500/20" : "bg-amber-500/10 border-amber-500/20"
              }`}
            >
              <div className="flex items-start justify-between gap-2">
                <div>
                  <div className="text-[12px] font-semibold text-zinc-950/90 dark:text-white/90">
                    {result.ok ? "Correct" : "Upgrade needed"}
                  </div>
                  <div className="text-[12px] text-zinc-950/65 dark:text-white/65 mt-1 leading-snug">
                    {result.msg}
                  </div>
                  <div className="text-[11px] text-zinc-950/45 dark:text-white/45 mt-2">
                    SRS: this card returns{" "}
                    <span className="text-zinc-950/70 dark:text-white/70 font-semibold">{nextReview}</span>
                  </div>
                </div>
                <button
                  onClick={next}
                  className="px-3 py-2 rounded-2xl bg-black/5 dark:bg-white/10 border border-black/10 dark:border-white/10 text-[12px] text-zinc-950/80 dark:text-white/80"
                >
                  Next
                </button>
              </div>

              <div className="mt-2 text-[11px] text-zinc-950/50 dark:text-white/50">
                Haptic simulation: {result.haptic === "correct" ? "✔ micro-bounce" : "⚠ pulse"}
              </div>
            </motion.div>
          ) : null}
        </div>

        <div className="p-4 rounded-3xl border border-black/10 dark:border-white/10 bg-gradient-to-b from-black/5 dark:from-white/6 to-transparent">
          <div className="text-[12px] font-semibold text-zinc-950/90 dark:text-white/90">Why this matters</div>
          <div className="mt-2 text-[12px] text-zinc-950/60 dark:text-white/60 leading-snug">
            Retrieval under time pressure builds executive reflexes. This improves retention and boosts conversion by
            making progress feel tangible.
          </div>
        </div>
      </div>
    </ScreenShell>
  );
}

// ───────────────────────────────────────────────────────────────────────────────
// FEATURES: REVISION (Stage 4)
// ───────────────────────────────────────────────────────────────────────────────
function RevisionScreen() {
  const { navTo, profile, openPaywall } = useApp();
  const template = `Net-net: ${profile.dashboardMetric}. We’ve identified the primary drivers, and we’re executing a mitigation plan now. My recommendation is to stabilize the trend within 2 weeks, while preserving customer trust. I’ll confirm corrective actions and a revised timeline within the hour.`;

  return (
    <ScreenShell
      title="Battle Card"
      left={<BackButton />}
      right={<Pill icon={Crown} label="Stage 4/4" variant="success" />}
      footer={
        <div className="space-y-2">
          <PrimaryButton icon={Lock} onClick={() => openPaywall("Competency Map + Pricing")}
          >
            Unlock Competency Map
          </PrimaryButton>
          <SecondaryButton icon={ArrowRight} onClick={() => navTo(ROUTES.Premium)}>
            Preview Premium Experience
          </SecondaryButton>
        </div>
      }
    >
      <div className="space-y-3">
        <div className="p-4 rounded-3xl border border-black/10 dark:border-white/10 bg-gradient-to-b from-emerald-500/12 to-transparent">
          <div className="text-[12px] text-zinc-950/55 dark:text-white/55">Mission-ready anchor</div>
          <div className="mt-1 text-[15px] font-semibold text-zinc-950/90 dark:text-white/90">
            Your executive briefing — in one card.
          </div>
          <div className="mt-2 text-[12px] text-zinc-950/60 dark:text-white/60 leading-snug">
            This is your “meeting cheat sheet.” It compresses clarity + tone + commitment.
          </div>
        </div>

        <div className="p-4 rounded-3xl border border-black/10 dark:border-white/10 bg-white/70 dark:bg-white/5">
          <div className="flex items-center justify-between">
            <div>
              <div className="text-[11px] text-zinc-950/55 dark:text-white/55">Context</div>
              <div className="text-[13px] font-semibold text-zinc-950/90 dark:text-white/90">
                {profile.role} @ {profile.company}
              </div>
            </div>
            <Pill
              icon={ShieldCheck}
              label={profile.hydrated ? "Hydrated" : "Demo"}
              variant={profile.hydrated ? "success" : "warn"}
            />
          </div>

          <div className="mt-3 grid grid-cols-3 gap-2">
            <MiniMetric label="Clarity" value="82" />
            <MiniMetric label="Tone" value="76" />
            <MiniMetric label="Commitment" value="88" />
          </div>

          <div className="mt-3 p-3 rounded-2xl bg-black/5 dark:bg-black/30 border border-black/10 dark:border-white/10">
            <div className="text-[11px] text-zinc-950/55 dark:text-white/55">Prefilled executive template (RAG-aware)</div>
            <div className="mt-2 text-[12px] text-zinc-950/80 dark:text-white/80 leading-snug">“{template}”</div>
          </div>

          <div className="mt-3 grid grid-cols-2 gap-2">
            <button className="px-3 py-3 rounded-2xl bg-zinc-950 text-white dark:bg-white dark:text-zinc-950 font-semibold">
              Export cheat sheet
            </button>
            <button className="px-3 py-3 rounded-2xl bg-black/5 dark:bg-white/10 border border-black/10 dark:border-white/10 text-zinc-950 dark:text-white font-semibold">
              Practice again
            </button>
          </div>

          <div className="mt-3 text-[11px] text-zinc-950/50 dark:text-white/50">
            Haptic simulation: ✔ subtle confirmation pulse on export.
          </div>
        </div>

        <div className="p-4 rounded-3xl border border-black/10 dark:border-white/10 bg-gradient-to-b from-black/5 dark:from-white/6 to-transparent">
          <div className="text-[12px] font-semibold text-zinc-950/90 dark:text-white/90">Retention loop</div>
          <div className="mt-2 text-[12px] text-zinc-950/60 dark:text-white/60 leading-snug">
            Reward (executive rewrite) → investment (save/export) → habit (streak) → LTV.
          </div>
        </div>
      </div>
    </ScreenShell>
  );
}

function MiniMetric({ label, value }) {
  return (
    <div className="p-2 rounded-2xl bg-white/70 dark:bg-white/5 border border-black/10 dark:border-white/10">
      <div className="text-[10px] text-zinc-950/50 dark:text-white/50">{label}</div>
      <div className="text-[14px] font-semibold text-zinc-950/90 dark:text-white/90 mt-0.5">{value}</div>
    </div>
  );
}

// ───────────────────────────────────────────────────────────────────────────────
// FEATURES: PAYWALL (Gap Analysis + Loss Aversion)
// ───────────────────────────────────────────────────────────────────────────────
function PaywallScreen() {
  const { navTo, setPlan, paywallIntent, setPaywallIntent } = useApp();

  const origin = paywallIntent?.from ?? ROUTES.Priming;
  const feature = paywallIntent?.feature ?? "Premium features";

  const completePurchase = (planId) => {
    setPlan(planId);
    setPaywallIntent(null);
    navTo(origin);
  };

  const map = [
    { skill: "Tone authority", l1: 42, l3: 86 },
    { skill: "Structured briefing", l1: 48, l3: 90 },
    { skill: "Metrics storytelling", l1: 39, l3: 84 },
    { skill: "Handling objections", l1: 36, l3: 82 },
  ];

  const plans = [
    {
      tag: "Free",
      title: "Starter",
      price: "€0",
      cadence: "forever",
      highlight: false,
      perks: [
        "1 scenario (Self-intro)",
        "Tier 1→2 suggestions",
        "Basic synonym quiz",
        "Limited streak tracking",
      ],
      cta: "Keep training (Free)",
      action: () => completePurchase("free"),
    },
    {
      tag: "Most Popular",
      title: "Premium",
      price: "€12.99",
      cadence: "/month",
      highlight: true,
      perks: [
        "Full briefing library (Crisis, Standups, Negotiation)",
        "Real-time coach (streaming tips)",
        "Dashboard OCR + RAG personalization",
        "Tier 3 executive rewrites",
        "SRS mastery scheduling",
      ],
      cta: "Unlock Premium",
      action: () => completePurchase("premium"),
    },
    {
      tag: "One-shot",
      title: "Crisis Sprint Pack",
      price: "€19.99",
      cadence: "one-time",
      highlight: false,
      perks: [
        "7-day high-pressure sprint",
        "Executive rewrite templates",
        "Rapid quiz drills",
        "Interview/Crisis variants",
      ],
      cta: "Buy Sprint Pack",
      action: () => completePurchase("sprint"),
    },
  ];

  return (
    <ScreenShell
      title="Paywall"
      left={<BackButton />}
      right={
        <button
          onClick={() => completePurchase("premium")}
          className="inline-flex items-center gap-2 px-3 py-2 rounded-2xl border border-amber-500/25 bg-amber-500/10 hover:bg-amber-500/14 text-[12px] font-semibold text-amber-900/90 dark:text-amber-100 active:scale-[0.99]"
        >
          <Crown size={16} className="opacity-90" />
          Upgrade
        </button>
      }
      footer={
        <div className="space-y-2">
          <PrimaryButton icon={Crown} onClick={() => completePurchase("premium")}>
            Unlock Premium
          </PrimaryButton>
          <SecondaryButton onClick={() => navTo(origin)}>Not now</SecondaryButton>
        </div>
      }
    >
      <div className="space-y-3">
        <div className="p-4 rounded-3xl border border-black/10 dark:border-white/10 bg-gradient-to-b from-amber-500/12 to-transparent">
          <div className="text-[12px] text-zinc-950/55 dark:text-white/55">Paywall • Unlock</div>
          <div className="mt-1 text-[12px] text-amber-900/80 dark:text-amber-100/80">
            Feature requested: <span className="font-semibold">{feature}</span>
          </div>
          <div className="mt-1 text-[15px] font-semibold text-zinc-950/90 dark:text-white/90">
            Every Tier 1 meeting costs authority.
          </div>
          <div className="mt-2 text-[12px] text-zinc-950/60 dark:text-white/60 leading-snug">
            Don’t just “speak English.” Speak leadership. Unlock Tier 3 language, live coaching, and personalized
            scenarios from your real metrics.
          </div>
        </div>

        <div className="p-4 rounded-3xl border border-black/10 dark:border-white/10 bg-white/70 dark:bg-white/5">
          <div className="flex items-center justify-between">
            <div>
              <div className="text-[11px] text-zinc-950/55 dark:text-white/55">Your current level</div>
              <div className="text-[13px] font-semibold text-zinc-950/90 dark:text-white/90">Tier 1–2 (inconsistent)</div>
            </div>
            <div>
              <div className="text-[11px] text-zinc-950/55 dark:text-white/55 text-right">Target requirement</div>
              <div className="text-[13px] font-semibold text-zinc-950/90 dark:text-white/90 text-right">
                Tier 3 (executive)
              </div>
            </div>
          </div>

          <div className="mt-3 space-y-3">
            {map.map((row) => (
              <div
                key={row.skill}
                className="p-3 rounded-2xl bg-black/5 dark:bg-black/30 border border-black/10 dark:border-white/10"
              >
                <div className="flex items-center justify-between">
                  <div className="text-[12px] text-zinc-950/80 dark:text-white/80 font-semibold">{row.skill}</div>
                  <div className="text-[11px] text-zinc-950/50 dark:text-white/50">L1→L3</div>
                </div>
                <div className="mt-2 grid grid-cols-2 gap-2">
                  <div>
                    <div className="text-[10px] text-zinc-950/45 dark:text-white/45">Current</div>
                    <div className="mt-1">
                      <ProgressBar value={row.l1} />
                    </div>
                  </div>
                  <div>
                    <div className="text-[10px] text-zinc-950/45 dark:text-white/45">Required</div>
                    <div className="mt-1">
                      <ProgressBar value={row.l3} />
                    </div>
                  </div>
                </div>
                <div className="mt-2 text-[11px] text-zinc-950/50 dark:text-white/50">
                  Loss aversion: every meeting at Tier 1 leaks credibility.
                </div>
              </div>
            ))}
          </div>
        </div>

        <div className="p-4 rounded-3xl border border-black/10 dark:border-white/10 bg-gradient-to-b from-black/5 dark:from-white/6 to-transparent">
          <div className="flex items-center justify-between">
            <div>
              <div className="text-[12px] font-semibold text-zinc-950/90 dark:text-white/90">Choose your upgrade</div>
              <div className="text-[12px] text-zinc-950/60 dark:text-white/60 mt-1">
                Pricing built to maximize activation + LTV.
              </div>
            </div>
            <Pill icon={Crown} label="Pricing" variant="muted" />
          </div>

          <div className="mt-3 space-y-2">
            {plans.map((p) => (
              <div
                key={p.title}
                className={`p-3 rounded-3xl border ${
                  p.highlight
                    ? "bg-amber-500/10 border-amber-500/25"
                    : "bg-white/70 dark:bg-white/5 border-black/10 dark:border-white/10"
                }`}
              >
                <div className="flex items-start justify-between gap-3">
                  <div>
                    <div className="inline-flex items-center gap-2">
                      <span
                        className={`px-2.5 py-1 rounded-full text-[11px] border ${
                          p.highlight
                            ? "bg-amber-500/15 border-amber-500/25 text-amber-900/90 dark:text-amber-100"
                            : "bg-black/5 dark:bg-white/6 border-black/10 dark:border-white/10 text-zinc-950/70 dark:text-white/70"
                        }`}
                      >
                        {p.tag}
                      </span>
                      <span className="text-[13px] font-semibold text-zinc-950/90 dark:text-white/90">
                        {p.title}
                      </span>
                    </div>

                    <div className="mt-1 flex items-end gap-2">
                      <div className="text-[22px] font-extrabold text-zinc-950/90 dark:text-white/90">
                        {p.price}
                      </div>
                      <div className="text-[12px] text-zinc-950/55 dark:text-white/55 mb-[2px]">{p.cadence}</div>
                    </div>
                  </div>

                  <button
                    onClick={p.action}
                    className={`px-3 py-2 rounded-2xl text-[12px] font-semibold border transition active:scale-[0.99] ${
                      p.highlight
                        ? "bg-zinc-950 text-white dark:bg-white dark:text-zinc-950 border-black/10 dark:border-white/10"
                        : "bg-black/5 dark:bg-white/10 text-zinc-950 dark:text-white border-black/10 dark:border-white/10 hover:bg-black/10 dark:hover:bg-white/12"
                    }`}
                  >
                    {p.cta}
                  </button>
                </div>

                <div className="mt-2 grid grid-cols-2 gap-2">
                  {p.perks.map((x) => (
                    <div key={x} className="flex items-start gap-2">
                      <CheckCircle2 size={16} className="text-emerald-600 dark:text-emerald-200 mt-0.5" />
                      <div className="text-[11px] text-zinc-950/65 dark:text-white/65 leading-snug">{x}</div>
                    </div>
                  ))}
                </div>

                {p.highlight ? (
                  <div className="mt-2 text-[11px] text-zinc-950/55 dark:text-white/55">
                    ★ Best value: unlock Tier 3 rewrites + real-time coaching + personalization.
                  </div>
                ) : null}
              </div>
            ))}
          </div>

          <div className="mt-3 text-[11px] text-zinc-950/50 dark:text-white/50">
            Secure purchase flow (placeholder). In production: Stripe / RevenueCat + Supabase entitlements.
          </div>
        </div>

        <div className="p-4 rounded-3xl border border-black/10 dark:border-white/10 bg-gradient-to-b from-black/5 dark:from-white/6 to-transparent">
          <div className="text-[12px] font-semibold text-zinc-950/90 dark:text-white/90">Premium unlocks</div>
          <div className="mt-2 grid grid-cols-2 gap-2">
            <Benefit icon={Crown} title="Full briefing library" body="Crisis, standups, negotiations, leadership updates." />
            <Benefit icon={Upload} title="Dashboard OCR + RAG" body="Scenarios built from your real metrics." />
            <Benefit icon={Mic} title="Live coach" body="Streaming feedback with executive polish." />
            <Benefit icon={Zap} title="Retention engine" body="Streaks, SRS mastery, role-based packs." />
          </div>
        </div>
      </div>
    </ScreenShell>
  );
}

function Benefit({ icon: Icon, title, body }) {
  return (
    <div className="p-3 rounded-3xl bg-white/70 dark:bg-white/5 border border-black/10 dark:border-white/10">
      <div className="w-9 h-9 rounded-2xl bg-black/5 dark:bg-white/6 border border-black/10 dark:border-white/10 flex items-center justify-center">
        <Icon size={16} className="text-zinc-950/85 dark:text-white/85" />
      </div>
      <div className="mt-2 text-[12px] font-semibold text-zinc-950/90 dark:text-white/90">{title}</div>
      <div className="mt-1 text-[11px] text-zinc-950/55 dark:text-white/55 leading-snug">{body}</div>
    </div>
  );
}

// ───────────────────────────────────────────────────────────────────────────────
// FEATURES: PREMIUM PREVIEW
// ───────────────────────────────────────────────────────────────────────────────
function PremiumScreen() {
  const { navTo } = useApp();

  return (
    <ScreenShell
      title="Premium Preview"
      left={<BackButton />}
      right={<Pill icon={Crown} label="Premium" variant="success" />}
      footer={
        <div className="space-y-2">
          <PrimaryButton icon={ArrowRight} onClick={() => navTo(ROUTES.Priming)}>
            Start another briefing
          </PrimaryButton>
          <SecondaryButton onClick={() => navTo(ROUTES.Paywall)}>Back to Paywall</SecondaryButton>
        </div>
      }
    >
      <div className="space-y-3">
        <div className="p-4 rounded-3xl border border-black/10 dark:border-white/10 bg-gradient-to-b from-cyan-500/12 to-transparent">
          <div className="text-[12px] text-zinc-950/55 dark:text-white/55">What “magic” feels like</div>
          <div className="mt-1 text-[15px] font-semibold text-zinc-950/90 dark:text-white/90">
            Your AI coach becomes a real-time copilot.
          </div>
          <div className="mt-2 text-[12px] text-zinc-950/60 dark:text-white/60 leading-snug">
            Whisper → transcription. Python → intent + sophistication scoring. NestJS → orchestration. Supabase → secure memory.
          </div>
        </div>

        <div className="p-4 rounded-3xl border border-black/10 dark:border-white/10 bg-white/70 dark:bg-white/5">
          <div className="flex items-center justify-between">
            <div>
              <div className="text-[11px] text-zinc-950/55 dark:text-white/55">Premium modules</div>
              <div className="text-[13px] font-semibold text-zinc-950/90 dark:text-white/90">Briefing Library</div>
            </div>
            <Pill icon={Layers} label="Feature-first" />
          </div>

          <div className="mt-3 space-y-2">
            <LibraryItem title="Crisis Sprint" tag="One-shot pack" desc="High-pressure calls, executive rewrites, rapid SRS." />
            <LibraryItem title="Interview Sprint" tag="One-shot pack" desc="STAR answers, persuasion, leadership presence." />
            <LibraryItem title="Standup Mastery" tag="Premium" desc="Crisp updates, blockers, timelines, accountability." />
            <LibraryItem title="Negotiation Room" tag="Premium" desc="Anchoring, framing, concessions, closing language." />
          </div>
        </div>

        <div className="p-4 rounded-3xl border border-black/10 dark:border-white/10 bg-gradient-to-b from-black/5 dark:from-white/6 to-transparent">
          <div className="text-[12px] font-semibold text-zinc-950/90 dark:text-white/90">Retention plateau strategy</div>
          <div className="mt-2 text-[12px] text-zinc-950/60 dark:text-white/60 leading-snug">
            After 2–3 weeks, motivation dips. We re-trigger with new roles, scenario packs, streak boosters, and competency milestones.
          </div>
        </div>
      </div>
    </ScreenShell>
  );
}

function LibraryItem({ title, tag, desc }) {
  return (
    <div className="p-3 rounded-3xl bg-black/5 dark:bg-black/30 border border-black/10 dark:border-white/10">
      <div className="flex items-center justify-between">
        <div className="text-[13px] font-semibold text-zinc-950/90 dark:text-white/90">{title}</div>
        <span className="px-2.5 py-1 rounded-full bg-black/5 dark:bg-white/6 border border-black/10 dark:border-white/10 text-[11px] text-zinc-950/70 dark:text-white/70">
          {tag}
        </span>
      </div>
      <div className="mt-1 text-[11px] text-zinc-950/55 dark:text-white/55 leading-snug">{desc}</div>
    </div>
  );
}

// ───────────────────────────────────────────────────────────────────────────────
// NAV / ROUTER + BACK BUTTON
// ───────────────────────────────────────────────────────────────────────────────
function BackButton() {
  const { navBack } = useApp();
  return (
    <button
      onClick={navBack}
      className="w-9 h-9 rounded-2xl bg-black/5 dark:bg-white/6 border border-black/10 dark:border-white/10 flex items-center justify-center hover:bg-black/10 dark:hover:bg-white/8"
    >
      <ArrowLeft size={18} className="text-zinc-950/80 dark:text-white/80" />
    </button>
  );
}

function RouteRenderer({ route }) {
  switch (route) {
    case ROUTES.Welcome:
      return <WelcomeScreen />;
    case ROUTES.Onboarding:
      return <OnboardingScreen />;
    case ROUTES.Upload:
      return <UploadScreen />;
    case ROUTES.Priming:
      return <PrimingScreen />;
    case ROUTES.Speaking:
      return <SpeakingScreen />;
    case ROUTES.Quiz:
      return <QuizScreen />;
    case ROUTES.Revision:
      return <RevisionScreen />;
    case ROUTES.Paywall:
      return <PaywallScreen />;
    case ROUTES.Premium:
      return <PremiumScreen />;
    default:
      return <WelcomeScreen />;
  }
}

// ───────────────────────────────────────────────────────────────────────────────
// MAIN APP
// ───────────────────────────────────────────────────────────────────────────────
export default function App() {
  const [route, setRoute] = useState(ROUTES.Welcome);
  const [history, setHistory] = useState([ROUTES.Welcome]);

  const [profile, setProfile] = useState(defaultProfile);
  const [mode, setMode] = useState("deepWork");

  // Monetization / entitlements
  const [plan, setPlan] = useState("free"); // "free" | "premium" | "sprint"
  const hasPremium = plan !== "free";

  // Paywall intent: why user got sent here + return path
  const [paywallIntent, setPaywallIntent] = useState(null);

  const navTo = (next) => {
    setRoute(next);
    setHistory((h) => [...h, next]);
  };

  const navBack = () => {
    setHistory((h) => {
      if (h.length <= 1) return h;
      const nextHist = h.slice(0, -1);
      const prev = nextHist[nextHist.length - 1];
      setRoute(prev);
      return nextHist;
    });
  };

  const openPaywall = (feature) => {
    setPaywallIntent({ feature, from: route });
    navTo(ROUTES.Paywall);
  };

  // Force dark-mode globally (Dark-only as requested)
  useEffect(() => {
    try {
      const root = document.documentElement;
      root.classList.add("dark");
      root.style.colorScheme = "dark";
    } catch {
      // ignore
    }
  }, []);

  const isPaywallZone = useMemo(() => route === ROUTES.Paywall || route === ROUTES.Premium, [route]);

  const ctx = useMemo(
    () => ({
      route,
      navTo,
      navBack,
      profile,
      setProfile,
      mode,
      setMode,
      // monetization
      plan,
      setPlan,
      hasPremium,
      openPaywall,
      paywallIntent,
      setPaywallIntent,
      isPaywallZone,
    }),
    [route, profile, mode, plan, hasPremium, isPaywallZone, paywallIntent]
  );

  return (
    <AppContext.Provider value={ctx}>
      <div className="dark">
        <div className="min-h-screen w-full flex items-center justify-center p-6 bg-zinc-950">
          <div className="absolute inset-0 pointer-events-none">
            <div
              className={`absolute -top-40 left-1/2 -translate-x-1/2 w-[780px] h-[780px] rounded-full bg-gradient-to-b ${
                theme.modes[mode].glow
              } blur-3xl`}
            />
          </div>

          <MobileFrame>
            <ScreenTransition routeKey={route}>
              <RouteRenderer route={route} />
            </ScreenTransition>
          </MobileFrame>

          <div className="hidden lg:block ml-6 w-[360px]">
            <div className="p-4 rounded-3xl border border-black/10 dark:border-white/10 bg-white/70 dark:bg-white/5">
              <div className="text-[12px] text-zinc-950/60 dark:text-white/60">Prototype blueprint</div>
              <div className="mt-1 text-[14px] font-semibold text-zinc-950/90 dark:text-white/90">
                React → Flutter translation-ready
              </div>
              <div className="mt-2 text-[12px] text-zinc-950/60 dark:text-white/60 leading-snug">
                Feature-first modules, typed state ownership (hooks/context), Impeller-like motion (Framer Motion), and RAG
                hydration simulation.
              </div>

              <div className="mt-3 flex flex-wrap gap-2">
                <Pill icon={Layers} label="Feature Modules" />
                <Pill icon={MessageSquareText} label="Realtime Coach" />
                <Pill icon={Upload} label="RAG Upload" />
                <Pill icon={Crown} label="Tier 3" variant="success" />
              </div>

              <div className="mt-4 text-[11px] text-zinc-950/45 dark:text-white/45">
                Tip: Run through the journey: Welcome → Upload → Priming → Speaking → Quiz → Revision → Paywall.
              </div>
            </div>

            <div className="mt-3 p-4 rounded-3xl border border-black/10 dark:border-white/10 bg-white/70 dark:bg-white/5">
              <div className="text-[12px] font-semibold text-zinc-950/90 dark:text-white/90">3-month roadmap</div>
              <ul className="mt-2 space-y-2 text-[12px] text-zinc-950/60 dark:text-white/60">
                <li>• Role-based libraries + sprint packs (Interview/Crisis)</li>
                <li>• Streak boosters + mastery milestones (churn defense)</li>
                <li>• Real RAG: CV/PDF/Excel structure → semantic pools</li>
                <li>• Offline-first review mode (Flutter: Isar/Hive + Riverpod)</li>
              </ul>
            </div>

            <div className="mt-3 p-4 rounded-3xl border border-black/10 dark:border-white/10 bg-white/70 dark:bg-white/5">
              <div className="text-[12px] font-semibold text-zinc-950/90 dark:text-white/90">Architecture mapping</div>
              <div className="mt-2 text-[12px] text-zinc-950/60 dark:text-white/60 leading-snug">
                <span className="text-zinc-950/80 dark:text-white/80 font-semibold">Supabase</span>: auth/storage/realtime/pgvector + RLS
                <br />
                <span className="text-zinc-950/80 dark:text-white/80 font-semibold">NestJS</span>: DDD orchestration + WebSockets control channel
                <br />
                <span className="text-zinc-950/80 dark:text-white/80 font-semibold">Python</span>: RAG ingestion + embeddings + scoring + Whisper
                <br />
                <span className="text-zinc-950/80 dark:text-white/80 font-semibold">Flutter</span>: Impeller rendering + Riverpod derived state
              </div>
            </div>
          </div>
        </div>
      </div>
    </AppContext.Provider>
  );
}

// ───────────────────────────────────────────────────────────────────────────────
// DEV SANITY CHECKS (non-blocking)
// ───────────────────────────────────────────────────────────────────────────────
// Lightweight assertions to catch regressions during prompt-iteration.
try {
  const isDev =
    typeof process !== "undefined" &&
    process?.env &&
    String(process.env.NODE_ENV || "").toLowerCase() !== "production";

  if (isDev) {
    const s1 = computeSophisticationScore("uh um like");
    const s2 = computeSophisticationScore(
      "Therefore, we identified the root cause and will confirm corrective actions with a measurable timeline."
    );

    console.assert(s1 >= 0 && s1 <= 100, "Sophistication score should be clamped 0..100");
    console.assert(s2 >= s1, "Executive language should score higher than filler-heavy language");
    console.assert(clamp(200, 0, 100) === 100, "Clamp upper bound failed");
    console.assert(clamp(-10, 0, 100) === 0, "Clamp lower bound failed");

    console.assert(
      detectIntentCluster("We have a delay; ETA tomorrow") === "Reporting a delay",
      "Intent detection failed"
    );
    console.assert(
      detectIntentCluster("Revenue is down vs forecast") === "Sharing bad news",
      "Intent detection for bad news failed"
    );

    const up = generateTierUpgrade("We have a problem", "Sharing bad news");
    console.assert(Boolean(up?.tier3), "Tier upgrade must return tier3 text");
  }
} catch {
  // ignore
}
