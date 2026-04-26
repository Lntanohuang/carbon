import { cn } from "@carbon/react";
import { useCallback, useEffect, useState } from "react";
import { LuBot, LuX } from "react-icons/lu";

const HERMES_URL = "http://localhost:9119/chat";
const STORAGE_KEY = "pleato-panel-open";

export function PleatoPanel() {
  const [isOpen, setIsOpen] = useState(() => {
    if (typeof window === "undefined") return false;
    return localStorage.getItem(STORAGE_KEY) === "true";
  });

  const toggle = useCallback(() => {
    setIsOpen((prev) => {
      const next = !prev;
      localStorage.setItem(STORAGE_KEY, String(next));
      return next;
    });
  }, []);

  // Keyboard shortcut: Ctrl+Shift+P to toggle
  useEffect(() => {
    function handleKeyDown(e: KeyboardEvent) {
      if (e.ctrlKey && e.shiftKey && e.key === "P") {
        e.preventDefault();
        toggle();
      }
    }
    window.addEventListener("keydown", handleKeyDown);
    return () => window.removeEventListener("keydown", handleKeyDown);
  }, [toggle]);

  return (
    <>
      {/* Floating toggle button */}
      <button
        type="button"
        onClick={toggle}
        className={cn(
          "fixed bottom-6 right-6 z-50",
          "flex items-center gap-2 px-4 py-3 rounded-full",
          "bg-primary text-primary-foreground shadow-lg",
          "hover:bg-primary/90 transition-all duration-200",
          "hover:shadow-xl hover:scale-105",
          isOpen && "hidden"
        )}
        title="小折 AI 助手 (Ctrl+Shift+P)"
      >
        <LuBot className="w-5 h-5" />
        <span className="text-sm font-medium">小折</span>
      </button>

      {/* Slide-in panel */}
      <div
        className={cn(
          "fixed top-0 right-0 z-40 h-full",
          "bg-background border-l shadow-2xl",
          "transition-transform duration-300 ease-in-out",
          "w-[420px]",
          isOpen ? "translate-x-0" : "translate-x-full"
        )}
      >
        {/* Panel header */}
        <div className="flex items-center justify-between px-4 py-3 border-b bg-muted/50">
          <div className="flex items-center gap-2">
            <LuBot className="w-5 h-5 text-primary" />
            <span className="font-semibold text-sm">小折 AI 助手</span>
          </div>
          <button
            type="button"
            onClick={toggle}
            className="p-1 rounded-md hover:bg-muted transition-colors"
            title="关闭 (Ctrl+Shift+P)"
          >
            <LuX className="w-4 h-4" />
          </button>
        </div>

        {/* Hermes Agent iframe */}
        {isOpen && (
          <iframe
            src={HERMES_URL}
            className="w-full h-[calc(100%-49px)] border-0"
            title="小折 AI Assistant"
            allow="clipboard-write"
          />
        )}
      </div>

      {/* Backdrop overlay on mobile */}
      {isOpen && (
        <div
          className="fixed inset-0 z-30 bg-black/20 sm:hidden"
          onClick={toggle}
          onKeyDown={() => {}}
          role="presentation"
        />
      )}
    </>
  );
}
