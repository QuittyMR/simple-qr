<script>
    import {tick, onDestroy} from 'svelte'
    import QrScanner from 'qr-scanner'

    let isStarted = false
    let videoElement
    let qrScanner
    let foundElement

    function decodeQR(result) {
        foundElement = result.data
    }

    async function activateCamera() {
        isStarted = true
        await tick();
        qrScanner = new QrScanner(videoElement, decodeQR, {
            highlightCodeOutline: true,
            highlightScanRegion: true,
            returnDetailedScanResult: true,
        });
        await qrScanner.start()
    }

    function stopCamera() {
        isStarted = false
        qrScanner.stop()
        qrScanner.destroy()
    }

    function closeResult() {
        foundElement = false
    }

    onDestroy(() => {
            stopCamera()
        }
    )
    activateCamera()
</script>

<svelte:head>
    <style>
        .scan-region-highlight {
            border-radius: 30px;
            outline: rgba(0, 0, 0, .25) solid 50vmax;
        }

        .scan-region-highlight-svg {
            display: none;
        }

        .code-outline-highlight {
            stroke: rgba(255, 255, 255, .5) !important;
            stroke-width: 15 !important;
            stroke-dasharray: none !important;
        }
    </style>
</svelte:head>
<div>
    <div id="options-container">
        <label>
            <input type="checkbox"/>
            Auto-follow results
        </label>
    </div>
    {#if isStarted}
        <div id="video-container">
            <video bind:this={videoElement}></video>
        </div>
    {/if}
</div>
{#if foundElement}
    <div id="result">
        <p>{foundElement}</p>
        <button class="modal-button" on:click={closeResult}>close</button>
    </div>
{/if}

<style>
    #options-container {
        position: absolute;
        z-index: 100;
        background-size: max-content;
        background-color: rgba(255, 255, 255, .5);
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
        width:100vw;
        height:100vh;
        overflow:hidden;
    }

    #result {
        position: absolute;
        width: 100vw;
        height: max-content;
        background-color: grey;
        z-index: 9999;
        text-align: center;
        border-radius: 20px;
        top: 0;
        left: 0;
    }
</style>