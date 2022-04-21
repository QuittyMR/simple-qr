<script>
    import { tick, onDestroy } from "svelte";
    import QrScanner from "qr-scanner";

    let isStarted = false;
    let videoElement;
    let qrScanner;
    let foundResult;
    let resultMessage;

    function decodeQR(result) {
        if (foundResult) {
            foundResult = undefined;
        } else {
            foundResult = result.data;
        }
    }

    async function activateCamera() {
        isStarted = true;
        await tick();
        qrScanner = new QrScanner(videoElement, decodeQR, {
            highlightCodeOutline: true,
            highlightScanRegion: true,
            returnDetailedScanResult: true,
        });
        await qrScanner.start();
    }

    function stopCamera() {
        isStarted = false;
        qrScanner.stop();
        qrScanner.destroy();
    }

    function closeResult() {
        foundResult = undefined;
    }

    onDestroy(() => {
        stopCamera();
    });
    activateCamera();
</script>

<svelte:head>
    <style>
        .scan-region-highlight {
            border-radius: 30px;
            outline: rgba(0, 0, 0, 0.25) solid 50vmax;
        }

        .scan-region-highlight-svg {
            display: none;
        }

        .code-outline-highlight {
            stroke: rgba(255, 255, 255, 0.5) !important;
            stroke-width: 15 !important;
            stroke-dasharray: none !important;
        }
    </style>
</svelte:head>
<div>
    <div id="options-container" class="flex flex-col">
        <label>
            <input type="checkbox" />
            Auto-follow results
        </label>
        <button on:click={() => { decodeQR({ data: "This is a message" })}}
            >trigger result</button
        >
    </div>
    {#if isStarted}
        <div id="video-container">
            <video bind:this={videoElement}>
                <track kind="captions" />
            </video>
        </div>
    {/if}
</div>
    <div class="bottom-0 absolute duration-500 transition-all {foundResult ? "opacity-100" : "opacity-0"}" >
        {foundResult ? foundResult : ''}
    </div>

<style>
    #options-container {
        position: absolute;
        z-index: 100;
        background-size: max-content;
        background-color: rgba(255, 255, 255, 0.5);
    }

    video {
        width: max-content;
        height: max-content;
        max-width: -webkit-fill-available;
        max-height: -webkit-fill-available;
        z-index: -100;
    }

    #video-container {
        position: absolute;
        width: 100vw;
        height: 99vh;
        overflow: hidden;
    }

    /* #result {
        position: absolute;
        width: 100vw;
        height: max-content;
        background-color: grey;
        z-index: 9999;
        text-align: center;
        border-radius: 20px;
        top: 0;
        left: 0;
    } */
</style>
