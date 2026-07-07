<script lang="ts">
  import BrandLogo from '$lib/components/shared/BrandLogo.svelte';
  import { app } from '$lib/stores/app.svelte';

  interface Props {
    active?: boolean;
    revealing?: boolean;
  }

  let { active = true, revealing = false }: Props = $props();
</script>

{#if active}
  <div class="intro-shell" class:is-revealing={revealing}>
    <div class="intro-vignette" aria-hidden="true"></div>

    <div class="intro-content">
      <div class="intro-line intro-line-left"></div>

      <div class="intro-brand" class:is-revealing={revealing}>
        <BrandLogo size="lg" />
        <p class="intro-tagline">Welcome, {app.playerName}</p>
      </div>

      <div class="intro-line intro-line-right"></div>
    </div>
  </div>
{/if}

<style>
  .intro-shell {
    position: fixed;
    inset: 0;
    z-index: 100;
    display: flex;
    align-items: center;
    justify-content: center;
    background: #000;
    opacity: 1;
    transition: opacity 900ms cubic-bezier(0.4, 0, 0.2, 1);
    pointer-events: all;
  }

  .intro-shell.is-revealing {
    opacity: 0;
    pointer-events: none;
  }

  .intro-vignette {
    position: absolute;
    inset: 0;
    background: radial-gradient(
      ellipse at center,
      rgba(0, 0, 0, 0.15) 0%,
      rgba(0, 0, 0, 0.85) 100%
    );
    opacity: 1;
    transition: opacity 900ms cubic-bezier(0.4, 0, 0.2, 1);
  }

  .intro-shell.is-revealing .intro-vignette {
    opacity: 0;
  }

  .intro-content {
    position: relative;
    z-index: 1;
    display: flex;
    align-items: center;
    gap: 2rem;
  }

  .intro-line {
    height: 1px;
    width: 0;
    background: linear-gradient(90deg, transparent, rgb(255 255 255 / 0.35), transparent);
    opacity: 0;
  }

  .intro-line-left {
    animation: intro-line-left 1.1s ease-out 0.5s forwards;
  }

  .intro-line-right {
    animation: intro-line-right 1.1s ease-out 0.5s forwards;
  }

  .intro-brand {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 1.25rem;
    opacity: 0;
    transform: scale(0.92) translateY(10px);
    animation: intro-brand-in 1.3s cubic-bezier(0.22, 1, 0.36, 1) forwards;
  }

  .intro-brand.is-revealing {
    animation: intro-brand-out 1s cubic-bezier(0.4, 0, 1, 1) forwards;
  }

  .intro-tagline {
    font-size: 0.85rem;
    letter-spacing: 0.1em;
    color: rgb(255 255 255 / 0.55);
    opacity: 0;
    animation: intro-tagline-in 0.9s ease-out 0.9s forwards;
  }

  .intro-brand.is-revealing .intro-tagline {
    animation: intro-tagline-out 0.8s ease-in forwards;
  }

  @keyframes intro-line-left {
    from {
      width: 0;
      opacity: 0;
      transform: translateX(12px);
    }
    to {
      width: 5rem;
      opacity: 1;
      transform: translateX(0);
    }
  }

  @keyframes intro-line-right {
    from {
      width: 0;
      opacity: 0;
      transform: translateX(-12px);
    }
    to {
      width: 5rem;
      opacity: 1;
      transform: translateX(0);
    }
  }

  @keyframes intro-brand-in {
    to {
      opacity: 1;
      transform: scale(1) translateY(0);
    }
  }

  @keyframes intro-brand-out {
    to {
      opacity: 0;
      transform: scale(1.05) translateY(-14px);
    }
  }

  @keyframes intro-tagline-in {
    to {
      opacity: 1;
    }
  }

  @keyframes intro-tagline-out {
    to {
      opacity: 0;
    }
  }
</style>
